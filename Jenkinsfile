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

    stage('Deploy to Kubernetes') {
    // Use SSH private key for authentication
    sshagent(['my-ssh-key']) {
        // Deploy to Kubernetes using kubectl
        sh "scp -i \$SSH_PRIVATE_KEY ${WORKSPACE}/kubernetes-deployment.yaml ubuntu@ip-172-31-90-21:~/kubernetes-deployment.yaml"
        sh "ssh -i \$SSH_PRIVATE_KEY ubuntu@ip-172-31-90-21 'kubectl apply -f ~/kubernetes-deployment.yaml'"
        }
    }
}
