def cluster1 = [ 
    k8sUri: "https://seh-env-ak-seh-env-b65426-70dahrex.hcp.westeurope.azmk8s.io:443", 
    k8sCredential: 'K8S_TOKEN', 
    k8sConfig: 'seh/k8s/scripts/azure/values.yaml' 
]

def clusterMap = [ "AKS Cluster": cluster1 ]

pipeline {
     
    agent { label 'spartacus-builder' }

    parameters {
        string(name: 'IMAGE_NAME', defaultValue: 'spartacus', description: 'Name of the Spartacus image to deploy')
        
        string(name: 'IMAGE_VERSION', defaultValue: 'latest', description: 'Version of the Spartacus image to deploy')
        
        choice(name: 'CLUSTER', choices: ['AKS Cluster' ], description: 'Select the target cluster') 

        string(name: 'OCC_ENDPOINT', defaultValue: '', description: 'OCC endpoint for Spartacus (leave it blank to use the default value)')

        string(name: 'REPLICA', defaultValue: '', description: 'Number of replica to deploy (leave it blank to use the default value)')
    }

    environment {
        //Name of the spartacus image for node
        SPARTACUS_IMAGE_NODE = "<acr_name>.azurecr.io/${params.IMAGE_NAME}/node"

        //Name of the spartacus image for nginx
        SPARTACUS_IMAGE_NGINX = "<acr_name>.azurecr.io/${params.IMAGE_NAME}/nginx"

        //Target Cluster
        K8S_URI = "${clusterMap[params.CLUSTER].k8sUri}"
        K8S_CREDENTIAL = "${clusterMap[params.CLUSTER].k8sCredential}"
        K8S_CONFIG = "${clusterMap[params.CLUSTER].k8sConfig}"

    }

    stages {
        stage('Deploy K8s') {
            steps {
                script {
                    withKubeConfig([credentialsId: "${K8S_CREDENTIAL}", serverUrl: "${K8S_URI}"]) {                    
                        //Prepare Helm Upgrade
                        def helmUpgrade = "helm upgrade spartacus-ssr seh/k8s/helm/spartacus-ssr-chart -n spartacus-ssr"
                        helmUpgrade += " -f ${K8S_CONFIG}"
                        helmUpgrade += " --set spartacus.nginx.image.repository=${SPARTACUS_IMAGE_NGINX}"
                        helmUpgrade += " --set spartacus.nginx.image.tag=${params.IMAGE_VERSION}"
                        helmUpgrade += " --set spartacus.node.image.repository=${SPARTACUS_IMAGE_NODE}"
                        helmUpgrade += " --set spartacus.node.image.tag=${params.IMAGE_VERSION}"
                        if(!params.OCC_ENDPOINT.isEmpty()) {
                            helmUpgrade += " --set spartacus.occ=${OCC_ENDPOINT}"    
                        }
                        if(!params.REPLICA.isEmpty()) {
                            helmUpgrade += " --set replicaCount=${params.REPLICA}"    
                        }

                        //Execute Helm Upgrade
                        sh "${helmUpgrade}"
                    }   
                }
            }
        }
    }
}