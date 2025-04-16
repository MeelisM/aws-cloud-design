#!/bin/bash

# Script to build and push Docker images to Docker Hub
# Usage: ./build-and-push.sh [docker-username]

set -e  # Exit on any error

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH"
    exit 1
fi

# Check if user is logged in to Docker Hub
if ! docker info 2>/dev/null | grep -q "Username"; then
    echo "You are not logged in to Docker Hub."
    echo "Please run 'docker login' first."
    exit 1
fi

# Get Docker Hub username
if [ -z "$1" ]; then
    # If username not provided as argument, try to get from docker config
    DOCKER_USERNAME=$(docker info | grep Username | cut -d' ' -f2)
    
    if [ -z "$DOCKER_USERNAME" ]; then
        echo "Error: Docker Hub username not provided and not found in docker config"
        echo "Usage: ./build-and-push.sh [docker-username]"
        exit 1
    fi
else
    DOCKER_USERNAME=$1
fi

echo "Using Docker Hub username: $DOCKER_USERNAME"

# Directory containing Dockerfiles
DOCKERFILE_DIR="Dockerfiles"

# Check if Dockerfiles directory exists
if [ ! -d "$DOCKERFILE_DIR" ]; then
    echo "Error: Directory '$DOCKERFILE_DIR' does not exist"
    exit 1
fi

# Build and push each Dockerfile
for DOCKERFILE in $DOCKERFILE_DIR/Dockerfile.*; do
    # Extract service name from filename (after the dot)
    SERVICE_NAME=${DOCKERFILE#*Dockerfile.}
    
    echo "----------------------------------------"
    echo "Building image for $SERVICE_NAME..."
    
    # Build the Docker image
    docker build -t $DOCKER_USERNAME/$SERVICE_NAME:latest -f $DOCKERFILE .
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to build image for $SERVICE_NAME"
        exit 1
    fi
    
    echo "Pushing image $DOCKER_USERNAME/$SERVICE_NAME:latest to Docker Hub..."
    
    # Push the Docker image to Docker Hub
    docker push $DOCKER_USERNAME/$SERVICE_NAME:latest
    
    if [ $? -ne 0 ]; then
        echo "Error: Failed to push image for $SERVICE_NAME"
        exit 1
    fi
    
    echo "Successfully built and pushed $DOCKER_USERNAME/$SERVICE_NAME:latest"
done

echo "----------------------------------------"
echo "All images built and pushed successfully!"
echo "Images available on Docker Hub:"
for DOCKERFILE in $DOCKERFILE_DIR/Dockerfile.*; do
    SERVICE_NAME=${DOCKERFILE#*Dockerfile.}
    echo "- $DOCKER_USERNAME/$SERVICE_NAME:latest"
done