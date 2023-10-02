# Spartacus External Hosting in Jenkins

This documentation will help you to setup a jenkins environment for the CI.

## Service Account Setup
An operator, like Jenkins, can interact with the cluster using a [service account](./k8s/sa-jenkins-ssr.yaml) token.
 
Execute this command to create a service account for jenkins: 
```
kubectl apply -f jenkins/k8s/sa-jenkins-ssr.yaml
```

### Service Account Token
Each service account token can be generated with a specific validity:
```
kubectl create token jenkins -n spartacus-ssr --duration=720h
```

## Builder Setup
The builder VMSS can be used as a Jenkins slave node to deploy the Spartacus project. Install the [following](./agent.sh) tools:
```
ssh <VMSS_ADMIN_USERNAME>@<VMSS_PUBLIC_IP> 'bash -s' < jenkins/agent.sh
```

## Jenkins Setup

### Install Jenkins (local testing)
You can run jenkins locally to test the pipeline:
```
docker compose up
```
Connect to http://127.0.0.1:8080/ and proceed with a default installation.

### Install Required Plugins
The spartacus pipeline required the following plugin installed:
- https://plugins.jenkins.io/kubernetes-cli/
- https://plugins.jenkins.io/docker-workflow/

### Configure the Agent/Node
Create a new jenkins node (aka agent) as follow:
- Remote root directory: Any directory available in the builder VM (e.g. /home/builder/jenkins-agent)
- Labels: spartacus-builder
- Launch method: Launch Agent via SSH (use builder VMSS credentials)

### Configure the Credentials
The spartacus pipeline required the following credentials configured:
- [`Secret Text`] NPM_CREDENTIAL_SPARTACUS - NPM base64 token to access to "spartacus" repository - see [SAP HELP](https://help.sap.com/docs/SAP_COMMERCE_COMPOSABLE_STOREFRONT/10a8bc7f635b4e3db6f6bb7880e58a7d/7266f6f01edb4328b4e09df299ea09be.html?q=.npmrc#downloading-composable%0Astorefront-libraries-from-the-repository-based-shipment-channel) to generate it.
- [`Username/Password`] DOCKER_REPO_CREDENTIAL - Credential to access to docker repository (image repository).
- [`Secret Text`] K8S_TOKEN - The [service account token](#service-account-token) used to execute operation on the AKS cluster.

## Pipeline Setup
The project provides two simple pipelines as starting points for the CI/CD:

- [build.Jenkinsfile](./pipeline/build.Jenkinsfile) - pipeline used to build the Spartacus project and push the image on the remote repository.
- [deploy.Jenkinsfile](./pipeline/deploy.Jenkinsfile) - pipeline used to deploy the Spartacus helm chart to a remote cluster.

**NOTE** Import the two pipeline as [multibranch pipeline](https://www.jenkins.io/doc/book/pipeline/multibranch/#creating-a-multibranch-pipeline)

### Build Pipeline
Update the [build.Jenkinsfile](./pipeline/build.Jenkinsfile) to reflect the project's setting:
- SPARTACUS_APP_NAME: The name of the Spartacus application to build (defined in the package.json)
- SPARTACUS_REPO_URL: The ACR repository URL (e.g. https://<acr_name>.azurecr.io)
- SPARTACUS_IMAGE_NODE: The final name of the node image
- SPARTACUS_IMAGE_NGINX: The final name of the node image

### Deploy Pipeline
Update the [deploy.Jenkinsfile](./pipeline/deploy.Jenkinsfile) to reflect the project's setting:
- SPARTACUS_IMAGE_NODE: The name of the node image to deploy.
- SPARTACUS_IMAGE_NGINX: The name of the node image to deploy.

**NOTE**: The "clusterMap" is used to support multiple clusters to allow flexible deployments.

