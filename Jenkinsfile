pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    docker.build('sstark/cw02:${BUILD_NUMBER}')
                }
            }
        }

        stage('Test Container Launch') {
            steps {
                script {
                    // Run a command inside the container to ensure it launches successfully
                    docker.image("sstark/cw02:${BUILD_NUMBER}").inside {
                        sh 'echo "Container launched successfully"'
                    }
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Push Docker image to DockerHub
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        docker.image("sstark/cw02:${BUILD_NUMBER}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Deploy to Kubernetes (replace with your kubectl and kubeconfig details)
                    sh 'kubectl apply -f kubernetes-deployment.yaml'
                }
            }
        }
    }
}
