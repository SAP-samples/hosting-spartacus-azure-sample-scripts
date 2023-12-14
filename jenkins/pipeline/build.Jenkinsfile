pipeline {
     
    agent { label 'spartacus-builder' }

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'spartacus', description: 'Name of the Spartacus image to build')
        string(name: 'IMAGE_VERSION', defaultValue: 'latest', description: 'Version of the Spartacus image to build')
    }

    environment {
        //Spartacus Application to build as defined in the package.json
        SPARTACUS_APP_NAME = "mystore"
        
        //Image Repository URL (e.g. Docker Hub or Azure Container Registry server login)
        SPARTACUS_REPO_URL = "https://<acr_name>.azurecr.io"
    
        //Name of the spartacus image for node
        SPARTACUS_IMAGE_NODE = "${params.IMAGE_NAME}/node:${params.IMAGE_VERSION}"

        //Name of the spartacus image for nginx
        SPARTACUS_IMAGE_NGINX = "${params.IMAGE_NAME}/nginx:${params.IMAGE_VERSION}"
                    
    }

    stages {
        stage('Prepare Project') {
            environment {
                //See https://help.sap.com/docs/SAP_COMMERCE_COMPOSABLE_STOREFRONT/cfcf687ce2544bba9799aa6c8314ecd0/5de67850bd8d487181fef9c9ba59a31d.html#downloading-composable%0Astorefront-libraries-from-the-repository-based-shipment-channel
                NPM_CREDENTIAL_SPARTACUS = credentials('NPM_CREDENTIAL_SPARTACUS')
            }
            steps {                
                sh '''
                    echo "@spartacus:registry=https://73554900100900004337.npmsrv.base.repositories.cloud.sap/" > .npmrc
                    echo "//73554900100900004337.npmsrv.base.repositories.cloud.sap/:_auth=$NPM_CREDENTIAL_SPARTACUS" >> .npmrc
                    echo "always-auth=true" >> .npmrc
                '''
            }
        }
        stage('Build & Push - Node Image') {
            steps {
                script {
                    docker.withRegistry("${SPARTACUS_REPO_URL}", 'DOCKER_REPO_CREDENTIAL') {
                        def image = docker.build(SPARTACUS_IMAGE_NODE, "--build-arg SPARTACUS_APP_NAME=${SPARTACUS_APP_NAME} -f ./seh/docker/node/spartacus-node.dockerfile .")
                        image.push();
                    }
                }
            }
        }
        stage('Build & Push - Nginx Image') {
            steps {
                script {
                    docker.withRegistry("${SPARTACUS_REPO_URL}", 'DOCKER_REPO_CREDENTIAL') {
                        def image = docker.build(SPARTACUS_IMAGE_NGINX, "--build-arg SPARTACUS_APP_NAME=${SPARTACUS_APP_NAME} --build-arg SPARTACUS_SSR_IMAGE=${SPARTACUS_IMAGE_NODE} -f ./seh/docker/nginx/spartacus-nginx.dockerfile .")
                        image.push();
                    }
                }
            }
        }
    }
}
