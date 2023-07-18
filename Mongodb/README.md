# Install Helm Mongodb

### Configuration
configure Mongodb/values.yaml

### Package and install helm chart
```
helm package Mongodb/
helm install <helm-chart> --generate-name
```