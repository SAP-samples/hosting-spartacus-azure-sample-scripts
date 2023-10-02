# Spartacus on Kubernetes
This project contains the following resources:
- The [helm chart](./helm/spartacus-ssr-chart/) to install/upgrade/uninstall Spartacus on K8s.
- The utlity scripts used to deploy Spartacus on the [docker-desktop k8s](./scripts/local/) (local cluster).
- The utilty scripts used to deploy Spartacus on the [Azure](./scripts/azure/).

# Deploy on Local Cluster
The local cluster can be used for testing/troubleshooting.

## Enable k8s on docker-desktop
Enable the docker-desktop k8s cluster as described [here](https://docs.docker.com/desktop/kubernetes/).

## Point to the local cluster
The following scripts use [kubectl](https://kubernetes.io/docs/reference/kubectl/) & [helm](https://helm.sh/) to deploy the Spartacus project:
```
# Target cluster is docker-desktop
kubectl config use-context docker-desktop
```

## Configure the chart
Update the [k8s local configuration](./scripts/local/values.yaml) with your project's settings; specially:
```
spartacus:
  nginx:
    image:
      repository: <local spartacus image for nginx>
      tag: <local spartacus image tag for nginx>
  node:
    image:
      repository: <local spartacus image for node>
      tag:  <local spartacus image tag for node>
```

## Install on local cluster
Execute [this](./scripts/local/install.sh) script to install Spartacus on the local cluster:
```
./scripts/local/install.sh
```
**NOTE**: Remember to [point kubectl to the target cluster](#point-to-the-local-cluster) before executing this script.

Connect to https://localhost

## Upgrade spartacus chart
Update the configuration of the chart and execute [this](./scripts/local/upgrade.sh) script:
```
./scripts/local/upgrade.sh
```
**NOTE**: Remember to [point kubectl to the target cluster](#point-to-the-local-cluster) before executing this script.

## Uninstall from local cluster
Execute [this](./scripts/local/uninstall.sh) to uninstall Spartacus from the local cluster:
```
./scripts/local/uninstall.sh
```
**NOTE**: Remember to [point kubectl to the target cluster](#point-to-the-local-cluster) before executing this script.

# Deploy on Azure cluster
The deployment on the Azure cluster required two main steps:
- The provisioning of the Azure resources needed by the cluster.
- The installation of the Spartacus project on the AKS cluster.

## Azure Provisioning

### Resource Group Environment
Execute [this](./scripts/azure/utils/create-environment.sh) to create the environment:
```
./scripts/azure/utils/create-environment.sh
```
**NOTE** Adjust the "environment variable" of the script to reflect your environment settings.

### Resource Group Builder
Execute [this](./scripts/azure/utils/create-builder.sh) to create the builder
```
./scripts/azure/utils/create-builder.sh
```
**NOTE** Adjust the "environment variable" of the script to reflect your environment settings.

### System Hardening
Some hardening operation should be applied to the cluster to increase the security:
- The AKS access should be [restricted to authorized IP address](https://learn.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges) (e.g. only the builder VMSS IP).
- The network security group (NSG) of the builder resource group should include a rule to allow traffic on the port 22 for specific IP address (e.g. the jenkins master node). 

## Install on AKS

### Point to the AKS cluster
The following scripts use [kubectl](https://kubernetes.io/docs/reference/kubectl/) & [helm](https://helm.sh/) to deploy the Spartacus project:
```
kubectl config use-context <target cluster>
```

### Setup the image repository secret
Create a secret to connect K8s to the image repository
```
kubectl create secret docker-registry repo-pull-secret \
    --docker-server=<server> \
    --docker-username=<username> \
    --docker-password=<password> \
    --namespace=spartacus-ssr
```
**NOTE** Remember to [point to the aks cluster](#point-to-the-aks-cluster) before executing the command.

### Configure the charts
Update the [chart configuration](./scripts/azure/values.yaml) to reflect your project's settings; in particular:
```
spartacus:
  nginx:
    image:
      repository: <remote spartacus image for nginx>
      tag: <remote spartacus image tag for nginx>
  node:
    image:
      repository: <remote spartacus image for node>
      tag:  <remote spartacus image tag for node>

imagePullSecrets: [ name: <image repository secret> ]

hosts:
    - host: <hostname of the application>
      paths:
        - path: /
          pathType: Prefix
  tls: 
   - secretName: letsencrypt-secret
     hosts:
       - <hostname of the application>
```

The hostname of the application should be in the format: `DNS_LABEL`.`LOCATION`.cloudapp.azure.com
- The DNS_LABEL is the custom initial part of the hostname.
- The AZURE_LOCATION is the azure location of the AKS.

### Install the charts on Azure
Execute [this](./scripts/azure/install.sh) to install Spartacus on the AKS cluster:
```
./scripts/azure/install.sh <DNS_LABEL>
```
**NOTE** Remember to [point to the aks cluster](#point-to-the-aks-cluster) before executing the command.

The cluster should be availabe at: https://<DNS_LABEL>.<LOCATION>.cloudapp.azure.com

## Upgrade spartacus chart on Azure
Update the configuration of the chart and execute [this](./scripts/azure/upgrade.sh) script:
```
./scripts/azure/upgrade.sh
```
**NOTE** Remember to [point to the aks cluster](#point-to-the-aks-cluster) before executing the command.

## Uninstall the charts from Azure
Execute [this](./scripts/azure/uninstall.sh) to uninstall Spartacus from the AKS cluster:
```
./scripts/azure/uninstall.sh
```
**NOTE** Remember to [point to the aks cluster](#point-to-the-aks-cluster) before executing the command.

## Configure the Certificate
Update the settings in [issuer-prod.yaml](./yaml/issuer-prod.yaml) and load the configuration in K8s.
```
kubectl apply -f ./k8s/yaml/issuer-prod.yaml -n spartacus-ssr
```
**NOTE** Remember to [point to the aks cluster](#point-to-the-aks-cluster) before executing the command.

The certificate challenge can take some times to be resolved. 
In case of issue try to [re-deploy the Spartacus app](#upgrade-spartacus-chart-on-azure) or to check the [jetstack status](https://www.jetstack.io/blog/cert-manager-status-cert/)
