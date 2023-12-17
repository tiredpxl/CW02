node {
    def dockerImageName = 'sstark300/cw02'
    def dockerImageTag = '1.0'

    stage('Preparation') {
        // Get some code from a GitHub repository
        withCredentials([usernamePassword(credentialsId: 'GitHub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            // your pipeline steps here
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/tiredpxl/CW02.git']]])
        }
    }

    stage('Build Docker Image') {
        // Build Docker image
        sh "docker build -t ${dockerImageName}:${dockerImageTag} ."
    }

    stage('Test Container Launch') {
        // Test that a Container can be launched from the Image
        sh "docker run ${dockerImageName}:${dockerImageTag} echo 'Container launched successfully'"
    }

    stage('Push to DockerHub') {
        // Push Docker image to DockerHub
        withCredentials([usernamePassword(credentialsId: 'sstark300-dockerhub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
            sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
            sh "docker tag ${dockerImageName}:${dockerImageTag} ${dockerImageName}:${env.BUILD_NUMBER}"
            sh "docker push ${dockerImageName}:${dockerImageTag}"
            sh "docker push ${dockerImageName}:${env.BUILD_NUMBER}"
        }
    }

    //stage('Deploy to Kubernetes') {
            //steps {
                // Use SSH private key for authentication
                //withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
                    // Copy Kubernetes deployment YAML file
                    //sh """
                        //scp -i \$SSH_PRIVATE_KEY kubernetes-deployment.yaml ubuntu@ip-172-31-90-21:~/kubernetes-deployment.yaml
                        //ssh -i \$SSH_PRIVATE_KEY ubuntu@ip-172-31-90-21 'kubectl apply -f ~/kubernetes-deployment.yaml'
                    //"""
               // }
           // }
      //  }
    stage('Deploy to Kubernetes') {
            // Replace placeholder in deployment.yaml with the actual image name
            sh "sed -i 's,TEST_IMAGE_NAME,tiredpxl/cw02:$BUILD_NUMBER,' kubernetes-deployment.yaml"
            
            // Display the updated content of deployment.yaml
            sh "cat kubernetes-deployment.yaml"
    
            // Get pods in the Kubernetes cluster
            sh "kubectl get pods"
    
            // Apply changes in kubernetes-deployment.yaml to the Kubernetes cluster
            sh "kubectl apply -f kubernetes-deployment.yaml"
        }

}
