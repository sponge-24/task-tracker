pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = "YOUR_AWS_ACCOUNT_ID"
        AWS_REGION = "YOUR_AWS_REGION"
        ECR_REPOSITORY_NAME = "task-tracker-app"
        ECS_CLUSTER_NAME = "your-ecs-cluster-name"
        ECS_SERVICE_NAME = "your-ecs-service-name"
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
                script {
                    // Build the Docker image
                    sh "docker build -t ${ECR_REPOSITORY_NAME} ."

                    // Log in to Amazon ECR
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

                    // Tag the image for ECR
                    sh "docker tag ${ECR_REPOSITORY_NAME}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest"

                    // Push the image to ECR
                    sh "docker push ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPOSITORY_NAME}:latest"
                }
            }
        }

        stage('Deploy to AWS') {
            steps {
                script {
                    // Make the deploy script executable
                    sh "chmod +x deploy.sh"
                    // Run the deployment script
                    sh "./deploy.sh"
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
