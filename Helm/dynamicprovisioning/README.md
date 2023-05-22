# <Helm Dynamic Volume Provisioner>

# Description

Deploy dynamic volume provisioner in K8S


# Table of Contents

- [Requirements](#requirements)
- [Configuration](#configuration)
- [Installation](#installation)

# Requirements
These are the requirements to install the dynamic volume provisioner in K8S.

1) K8S cluster up and running

# Configuration
### Configure Vagrantfile

Modify the field "namespace" in values.yaml

# Installation
Package and install Helm Chart

#### Option 1. Package the folder ./dynamicprovisioning/ and install the tar.gz
```
cd ~
helm package dynamicprovisioning/
helm install dynamicprovisioning-0.1.0.tgz --generate-name 
```