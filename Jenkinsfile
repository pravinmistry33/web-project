pipeline {
    agent any

    environment {
        IMAGE_NAME = "pravinmistry33/web-app"
        KUBE_CONTEXT = "minikube" 
        DOCKER_CONFIG = "${WORKSPACE}/.docker" // Clean Docker config location
    }

    stages {
        stage('Setup Docker Config') {
            steps {
                sh 'mkdir -p $DOCKER_CONFIG && echo "{}" > $DOCKER_CONFIG/config.json'
            }
        }
        
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

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASS https://index.docker.io/v1/'
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
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }
}
