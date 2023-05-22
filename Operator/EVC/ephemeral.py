import os
import kopf
import kubernetes
import yaml
import logging

@kopf.on.create('ephemeralvolumeclaims')
def create_fn(spec, status, name, namespace, logger, **kwargs):
    
    logging.info(f'SPEC: {spec}')
    logging.info(f'STATUS: {status}')
    logging.info(f'name: {name}')
    logging.info(f'namespace: {namespace}')


    size = spec.get('size')
    storageClassName = spec.get('storageClassName')

    if not size:
        raise kopf.PermanentError(f"Size must be set. Got {size!r}.")
    if not storageClassName:
        raise kopf.PermanentError(f"storageClassName must be set. Got {storageClassName!r}.")

    path = os.path.join(os.path.dirname(__file__), 'pvc.yaml')
    tmpl = open(path, 'rt').read()
    text = tmpl.format(name=name, size=size, storageClassName=storageClassName)
    data = yaml.safe_load(text)

    kopf.adopt(data)

    api = kubernetes.client.CoreV1Api()
    obj = api.create_namespaced_persistent_volume_claim(
        namespace=namespace,
        body=data,
    )

    logger.info(f"PVC child is created: {obj}")

    return {'pvc-name': obj.metadata.name}


@kopf.on.update('ephemeralvolumeclaims')
def update_fn(spec, status, namespace, logger, **kwargs):

    size = spec.get('size', None)
    if not size:
        raise kopf.PermanentError(f"Size must be set. Got {size!r}.")

    pvc_name = status['create_fn']['pvc-name']
    pvc_patch = {'spec': {'resources': {'requests': {'storage': size}}}}

    api = kubernetes.client.CoreV1Api()
    obj = api.patch_namespaced_persistent_volume_claim(
        namespace=namespace,
        name=pvc_name,
        body=pvc_patch,
    )

    logger.info(f"PVC child is updated: {obj}")
    

# @kopf.on.field('ephemeralvolumeclaims', field='metadata.labels')
# def relabel(old, new, status, namespace, **kwargs):

#     pvc_name = status['create_fn']['pvc-name']
#     pvc_patch = {'metadata': {'labels': new}}

#     api = kubernetes.client.CoreV1Api()
#     obj = api.patch_namespaced_persistent_volume_claim(
#         namespace=namespace,
#         name=pvc_name,
#         body=pvc_patch,
#     )

@kopf.on.field('ephemeralvolumeclaims', field='metadata.labels')
def relabel(diff, status, namespace, **kwargs):

    labels_patch = {field[0]: new for op, field, old, new in diff}

    pvc_name = status['create_fn']['pvc-name']
    pvc_patch = {'metadata': {'labels': labels_patch}}
    logging.info(f'pv patch: {pvc_patch}')

    api = kubernetes.client.CoreV1Api()
    obj = api.patch_namespaced_persistent_volume_claim(
        namespace=namespace,
        name=pvc_name,
        body=pvc_patch,
    )

