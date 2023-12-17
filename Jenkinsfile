node {
    // Your checkout steps go here
    checkout scm

    // Your Docker build steps go here
    stage('Build Docker Image') {
        sh 'docker build -t sstark300/cw02:1.0 .'
    }

    // Your container launch test steps go here
    stage('Test Container Launch') {
        sh 'docker run sstark300/cw02:1.0 echo Container launched successfully'
    }

    // Your DockerHub push steps go here
    stage('Push to DockerHub') {
        withCredentials([usernamePassword(credentialsId: 'sstark300-dockerhub', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
            sh """
                docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD
                docker tag sstark300/cw02:1.0 sstark300/cw02:179
                docker push sstark300/cw02:1.0
                docker push sstark300/cw02:179
            """
        }
    }

    // Deploy to Kubernetes
    stage('Deploy to Kubernetes') {
        // Set the PATH variable
        def PATH = "/usr/local/bin:${env.PATH}"
        
        // Use SSH private key for authentication
        sshagent(['my-ssh-key']) {
            // Deploy to Kubernetes using kubectl
            sh """
                scp -i /var/lib/jenkins/.ssh/id_rsa kubernetes-deployment.yaml ubuntu@ip-172-31-90-21:~/kubernetes-deployment.yaml
                ssh -i /var/lib/jenkins/.ssh/id_rsa ubuntu@ip-172-31-90-21 '/usr/local/bin/kubectl apply -f ~/kubernetes-deployment.yaml'
            """
        }
    }
}
