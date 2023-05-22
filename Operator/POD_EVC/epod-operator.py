import os
import kopf
import kubernetes
import yaml
import logging
from kubernetes import client, config
from time import sleep
from random import randint
import threading

@kopf.on.create('ephemeralpod')
def create_fn(spec, status, meta, name, namespace, logger, **kwargs):

    api = kubernetes.client.CoreV1Api()
    # get label
    label_epod = meta['labels']['epod']
    create_only_pod = spec['create_only_pod']
    # get fields from epod instance
    volumes = spec['volumes'][0]
    containers = spec['containers'][0]
    volume_name = volumes['name']
    claim_name = volumes['persistentVolumeClaim']['claimName']
    pv_size = volumes['persistentVolumeClaim']['pv-size']
    storageClassName = volumes['persistentVolumeClaim']['storageClassName']
    container_name = containers['name']
    image_name = containers['image']
    ports = containers['ports'][0]
    container_port = ports['containerPort']
    port_name = ports['name']
    resources = containers["resources"]
    request_memory = resources['requests']['memory']
    request_cpu = resources['requests']['cpu']
    limit_memory = resources['limits']['memory']
    limit_cpu = resources['limits']['cpu']
    volumeMounts = containers["volumeMounts"][0]
    mount_path = volumeMounts['mountPath']
    mount_name = volumeMounts['name']

    logging.info(f'CREATE ONLY POD {create_only_pod}')
    # prepare pvc template and make it dependent from pod (i.e. if epod dies, also pvc dies )
    if create_only_pod == "no":
      path_pvc = os.path.join(os.path.dirname(__file__), 'pvc-template.yaml')
      tmpl_pvc = open(path_pvc, 'rt').read()
      text_pvc = tmpl_pvc.format(name=claim_name, label=name, size=pv_size, storageClassName=storageClassName)
      data_pvc = yaml.safe_load(text_pvc)
      kopf.adopt(data_pvc)

      obj_pvc = api.create_namespaced_persistent_volume_claim(
            namespace=namespace,
            body=data_pvc,
        )
      
    
        

    # prepare pod template and make pod dependent from epod. (i.e. if epod dies, also pod dies )
    name_pod = name + '-' + str(randint(0,100))
    path_pod = os.path.join(os.path.dirname(__file__), 'pod-template.yaml')
    tmpl_pod = open(path_pod, 'rt').read()
    text_pod = tmpl_pod.format(name=name_pod, label=name, volume_name=volume_name, claim_name=claim_name, container_name=container_name,
                              image_name=image_name, container_port=container_port, port_name=port_name,
                              request_memory=request_memory, request_cpu=request_cpu, limit_memory=limit_memory,
                              limit_cpu=limit_cpu, mount_path=mount_path, mount_name=mount_name)
    data_pod = yaml.safe_load(text_pod)
    kopf.adopt(data_pod)

    obj_pod = api.create_namespaced_pod(
      namespace=namespace,
      body=data_pod
    )

    return {'status': 'RUNNING'}

# @kopf.on.field('ephemeralpod', field='metadata.labels')
# def relabel(diff, status, namespace, **kwargs):

#     labels_patch = {field[0]: new for op, field, old, new in diff}

#     pvc_name = status['create_fn']['pvc-name']
#     pvc_patch = {'metadata': {'labels': labels_patch}}
#     logging.info(f'pv patch: {pvc_patch}')

#     api = kubernetes.client.CoreV1Api()
#     obj = api.patch_namespaced_persistent_volume_claim(
#         namespace=namespace,
#         name=pvc_name,
#         body=pvc_patch,
#     )



@kopf.on.delete('pods')
async def delete_fn(body, **kwargs):
    # Load Kubernetes configuration from default location
    config.load_kube_config()

# Create an instance of the Kubernetes API client
    api = client.CustomObjectsApi()

    # check if the deleted pod belongs to an existing epod instance
    epod_name = body.metadata.labels.get('epod')
    pod_name = body.metadata.name

    if epod_name:
        namespace = body.metadata.namespace

        # retrieve the corresponding epod instance
        try:
            
            epod = api.get_namespaced_custom_object(
                group='kopf.dev',
                version='v1',
                plural='ephemeralpods',
                name=epod_name,
                namespace=namespace,
            )
        except kubernetes.client.rest.ApiException as e:
            if e.status == 404:
                return
            else:
                raise
        
        epod['spec']['create_only_pod'] = "yes"
        create_only_pod = epod['spec']['create_only_pod']
        logging.info(f'AFTER DELETING: {create_only_pod}')

        # wait until pod disappears from cluster
        try_again = True
        while try_again:
            logging.info(f'Looking for pod {pod_name}')
            try:
                status_pod = api.get_namespaced_custom_object_status(
                    group='kopf.dev',
                    version='v1',
                    plural="pods",
                    name=epod_name,
                    namespace=namespace
                )
                logging.info(f'Pod {pod_name} still exists')
                sleep(1)

            except:
                logging.info(F'Pod {epod_name} not found')
                try_again = False

        # create a new pod and pvc

        #while status:

        sleep(1)
        
        # create_fn(
        #     spec=epod['spec'],
        #     meta=epod['metadata'],
        #     status=epod['status'],
        #     name=epod_name,
        #     namespace=namespace,
        #     logger=kwargs['logger'],
        # )  

        
        await kopf.execute(handlers=create_fn(spec=epod['spec'], status=epod['status'],
                                    meta=epod['metadata'], name=epod_name,
                                      namespace=namespace, logger=kwargs['logger']))

        return
            



    # logger.info(f"PVC child is created: {obj}")

    # return {'pvc-name': obj.metadata.name}