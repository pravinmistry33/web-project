pipeline {
    agent any

    environment {
        IMAGE_NAME = "pravinmistry33/web-app"
        KUBE_CONTEXT = "minikube" 
    }

    stages {
        stage('Check Kubernetes Context') {
            steps {
                sh 'kubectl config use-context $KUBE_CONTEXT'
                sh 'kubectl get pods --all-namespaces'
            }
        }
        
        stage('Clone Repository') {
            steps {
                script {
                    checkout([$class: 'GitSCM',
                        branches: [[name: '*/master']], // Change branch if needed
                        userRemoteConfigs: [[
                            url: 'https://github.com/pravinmistry33/web-project.git',
                            credentialsId: 'github-credentials' // Use the ID from Step 2
                        ]]
                    ])
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: 'https://index.docker.io/v1/']) {
                    sh 'docker push $IMAGE_NAME'
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }
}
