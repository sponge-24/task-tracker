pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "275851867352"
        AWS_REGION = "ap-south-1"
        ECR_REPOSITORY_NAME = "task-tracker"
        ECS_CLUSTER_NAME = "dramatic-kangaroo-e7louq"
        ECS_SERVICE_NAME = "container-service"
        ECS_TASK_DEFINITION_NAME = "task-tracker-task"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withAWS(credentials: '074bb87f-6764-4d6b-93e6-41d8012063cd', region: env.AWS_REGION) {
                    script {
                        // Build the Docker image
                        sh "docker build -t ${ECR_REPOSITORY_NAME} ."

                        // Get login password from ECR and log in
                        def ecrLoginPassword = sh(script: "aws ecr get-login-password --region ${env.AWS_REGION}", returnStdout: true).trim()
                        sh "echo ${ecrLoginPassword} | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com"

                        // Tag the image for ECR
                        sh "docker tag ${ECR_REPOSITORY_NAME}:latest ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest"

                        // Push the image to ECR
                        sh "docker push ${env.AWS_ACCOUNT_ID}.dkr.ecr.${env.AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest"
                    }
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                withAWS(credentials: 'aws-credentials-for-ecs', region: env.AWS_REGION) {
                    script {
                        // Make the deploy script executable
                        sh "chmod +x deploy.sh"
                        // Run the deployment script
                        sh "./deploy.sh"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
    }
}
