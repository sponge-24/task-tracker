#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define variables from Jenkins environment
AWS_REGION="$AWS_REGION"
ECR_REPO_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPOSITORY_NAME:latest"
ECS_CLUSTER="$ECS_CLUSTER_NAME"
ECS_SERVICE="$ECS_SERVICE_NAME"
TASK_DEFINITION_NAME="$ECS_TASK_DEFINITION_NAME"

echo "Starting deployment..."
echo "AWS Region: $AWS_REGION"
echo "ECS Cluster: $ECS_CLUSTER"
echo "ECS Service: $ECS_SERVICE"
echo "Task Definition Name: $TASK_DEFINITION_NAME"
echo "Image URL: $ECR_REPO_URL"

# Create a new task definition by substituting the image URL in the template
# and register it with ECS.
TASK_DEFINITION_JSON=$(sed "s|IMAGE_URL_PLACEHOLDER|${ECR_REPO_URL}|g" task-definition.json)
NEW_TASK_DEF_REVISION=$(aws ecs register-task-definition --cli-input-json "$TASK_DEFINITION_JSON" --region "$AWS_REGION" | jq -r '.taskDefinition.taskDefinitionArn')

echo "Registered new task definition: $NEW_TASK_DEF_REVISION"

# Update the ECS service to use the new task definition revision.
aws ecs update-service --cluster "$ECS_CLUSTER" --service "$ECS_SERVICE" --task-definition "$NEW_TASK_DEF_REVISION" --region "$AWS_REGION"

echo "Deployment successful! Service '$ECS_SERVICE' is updating."
