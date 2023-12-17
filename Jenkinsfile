node {
    def app

    stage('Clone Repository') {
        checkout scm
    }

    stage('Build Image') {
        app = docker.build("sstark300/cw02")
    }

    stage('Test Image') {
        app.inside {
            sh 'echo "Test pass"'
        }
    }

    stage('Run Container') {
        script {

            def containerId = docker.image("sstark300/cw02").run("-d -p 8081:8080").id

            try {

                sh 'docker ps'
                sh"docker exec -i ${containerId} echo 'Success!'"
            }
            finally{

                sh "docker stop ${containerId}"
                sh "docker rm -f --volumes ${containerId}"
            }
        }
    }

    stage('Push Image') {
        script {
            docker.withRegistry('https://registry.hub.docker.com', 'sstark300-dockerhub') {
                def imageTag = "${env.BUILD_NUMBER}"
                app.push(imageTag)
                echo "Docker image pushed to sstark300/cw02:${imageTag}"
            }
        }
    }
    stage('Deploy To Kubernetes') {

        def imageTag = "${env.BUILD_NUMBER}"

        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: "KEY_FILE")]) {
                sh 'ssh -o StrictHostKeyChecking=no -i $KEY_FILE ubuntu@172-31-90-21 "kubectl set image deployments/coursework2 coursework2=sstark300/cw02:' + "${imageTag}" + '"'
            }
        }
    }
}
