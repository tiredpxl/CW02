node {
    // Checkout code from Git
    checkout scm

    // Build Docker image
    stage('Build Docker Image') {
        echo 'Building Docker image...'
        docker.build('sstark/cw02:${BUILD_NUMBER}')
    }

    // Test Container Launch
    stage('Test Container Launch') {
        echo 'Testing container launch...'
        docker.image("sstark/cw02:${BUILD_NUMBER}").inside {
            sh 'echo "Container launched successfully"'
        }
    }

    // Push to DockerHub
    stage('Push to DockerHub') {
        echo 'Pushing Docker image to DockerHub...'
        docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
            docker.image("sstark/cw02:${BUILD_NUMBER}").push()
        }
    }

    // Deploy to Kubernetes
    stage('Deploy to Kubernetes') {
        echo 'Deploying to Kubernetes...'
        sh 'kubectl apply -f kubernetes-deployment.yaml'
    }
}

