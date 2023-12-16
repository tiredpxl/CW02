node {
    def dockerImageName = 'sstark300/cw02'
    def dockerImageTag = '1.0'

    stage('Preparation') {
        // Get some code from a GitHub repository
        withCredentials([usernamePassword(credentialsId: 'GitHub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        // your pipeline steps here
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/tiredpxl/CW02.git']]])
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
    withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'SSH_PRIVATE_KEY')]) {
        // Write the SSH private key to a temporary file
        writeFile file: 'temp-ssh-key', text: env.SSH_PRIVATE_KEY
        // Set proper permissions
        sh 'chmod 600 temp-ssh-key'
        // Deploy to Kubernetes using kubectl
        sh 'kubectl apply -f kubernetes-deployment.yaml --private-key=temp-ssh-key'
    }
}

}

}
