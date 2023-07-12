#!/usr/bin/env bash

name='KubeletDown'
url='http://t4srv100y0.ad04.eni.intranet:31000/api/v1/alerts'

generate_post_data() {
  cat <<EOF
[{
  "labels": {
    "alertname": "${name}",
    "job": "kubelet",
    "severity":"critical",
    "instance": "t4srv100y2.ad04.eni.intranet"
  },
  "annotations": {
    "message": "Kubelet has disappeared from Prometheus target discovery.",
    "description": "Kubelet has disappeared from Prometheus target discovery.",
    "summary": "[K8S Prod]"
  },
  "generatorURL": "http://localhost:9000/graph"
}]
EOF
}

echo "Firing alert ${name}"
printf -v startsAt ',"startsAt" : "%s"' $(date --rfc-3339=seconds | sed 's/ /T/')
POSTDATA=$(generate_post_data 'firing' "${startsAt}")
curl $url --data "$POSTDATA" --trace-ascii /dev/stdout
echo -e "\n"

echo "Press enter to resolve alert ${name}"
read

echo "Sending resolved"
printf -v endsAt ',"endsAt" : "%s"' $(date --rfc-3339=seconds | sed 's/ /T/')
POSTDATA=$(generate_post_data 'firing' "${startsAt}" "${endsAt}")
curl $url --data "$POSTDATA" --trace-ascii /dev/stdout
echo -e "\n"

