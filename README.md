# Spartacus External Hosting

<!--- Register repository https://api.reuse.software/register, then add REUSE badge:
[![REUSE status](https://api.reuse.software/badge/github.com/SAP-samples/REPO-NAME)](https://api.reuse.software/info/github.com/SAP-samples/REPO-NAME)
-->

## Description
This repository provides some sample scripts to support the hosting of a SSR Spartacus project in Azure.

## Disclaimer
Customer agrees to use Spartacus External Hosting on “as is” basis and SAP makes no guarantees or representations or warranties of any kind, express or implied, arising by law or otherwise, including but not limited to, content, quality, accuracy, completeness, effectiveness, reliability, fitness for a particular purpose, usefulness, use or results to be obtained from Spartacus External Hosting, or that Spartacus External Hosting will be uninterrupted or error-free.

## Requirements
The main requirements to use this project are:
- An Azure subscription to use for creating the required resource (e.g. AKS, ACR, etc.).
- A working Spartacus project with the SSR module enabled.
 
## Download and Installation
This project can be included into the Spartacus project as follow:
```
# Spartacus Project Root folder (contains the package.json)
cd $SPARTACUS_ROOT

# Clone the project inside the project's root
git clone <this_repository>

# Rename the cloned folder as ´seh´
mv <hosting-spartacus-azure-sample-scripts> seh
```

## How does it works
The project is composed of 3 main component:
- [docker](./docker/README.md) - build, tag & push the docker images of the Spartacus project.
- [k8s](./k8s/README.md) - prepare & deploy Spartacus on a K8s infrastructure (like Azure).
- [jenkins](./jenkins/README.md) - create a jenkins pipeline for the deployment.

**NOTE:** see the `README.md` of each component for more details.


## How to obtain support 
Spartacus External Hosting is provided "as-is" with no official lines of support.
To get help from the Spartacus External Hosting community, create an issue in this repository.

## Contributing
If you wish to contribute code, offer fixes or improvements, please send a pull request. Due to legal reasons, contributors will be asked to accept a DCO when they create the first pull request to this project. This happens in an automated fashion during the submission process. SAP uses [the standard DCO text of the Linux Foundation](https://developercertificate.org/).

## License
Copyright (c) 2023 SAP SE or an SAP affiliate company. All rights reserved. This project is licensed under the Apache Software License, version 2.0 except as noted otherwise in the [LICENSE](LICENSE) file.
