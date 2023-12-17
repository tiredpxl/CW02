pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'sstark300/cw02'
        DOCKER_IMAGE_TAG = '1.0'
        KUBERNETES_DEPLOYMENT_FILE = 'kubernetes-deployment.yaml'
    }

    stages {
        stage('Detect Changes') {
            steps {
                // Assuming you have GitHub webhook configured for the repository
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'GitHub', url: 'https://github.com/tiredpxl/CW02.git']]])
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                }
            }
        }

        stage('Test Container Launch') {
            steps {
                script {
                    // Test that a Container can be launched from the Image
                    sh "docker run ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} echo 'Container launched successfully'"
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                script {
                    // Push Docker image to DockerHub
                    withCredentials([usernamePassword(credentialsId: 'sstark300-dockerhub', usernameVariable: 'DOCKERHUB_USERNAME', passwordVariable: 'DOCKERHUB_PASSWORD')]) {
                    sh "docker login -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}"
                    sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker push ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}"
                    sh "docker push ${DOCKER_IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
    }

        stage('Deploy to Kubernetes') {
    // Use SSH private key for authentication
    sshagent(['my-ssh-key']) {
        // Deploy to Kubernetes using kubectl
        script {
            sh """
                echo "Copying kubernetes-deployment.yaml to the server"
                scp -i \$SSH_PRIVATE_KEY kubernetes-deployment.yaml ubuntu@ip-172-31-90-21:~/kubernetes-deployment.yaml || exit 1
                echo "Applying deployment on the server"
                ssh -i \$SSH_PRIVATE_KEY ubuntu@ip-172-31-90-21 'kubectl apply -f ~/kubernetes-deployment.yaml' || exit 1
            """
        }
    }
}

        }
    }
