#!/bin/bash
#
setting_variable () {
    sed -i "s/IMAGE_NAME/${IMAGE_NAME}/g" ./build-and-deploy.sh
    sed -i "s/MEMORY_RESERVATION/${MEMORY_RESERVATION}/g" ./deploy/apirest.json
    sed -i "s/CPU_UNITY/${CPU_UNITY}/g" ./deploy/apirest.json
    sed -i "s/HOST_PORT/${HOST_PORT}/g" ./deploy/apirest.json
    sed -i "s/IMAGE_REPOSITORY/${IMAGE_REPOSITORY}/g" ./deploy/apirest.json
    sed -i "s/TASK_NAME/${TASK_NAME}/g" ./deploy/apirest.json
}

#############
### BUILD ###
#############

#Build docker image
build_docker () {
    docker build -t ${IMAGE_NAME} .
}

#Compile the project to generate the jar file
compile_docker_image () {
    echo "Compiling the project to generate .jar"
    mvn clean install -DskipTests
    mvn clean package -DskipTests
    if [ $? -eq 0 ]; then
        echo "Compiled with Sucess, building the new docker image"
    else
        echo "Maven FAILED to compile, please check Jenkins errors"
        exit 1
    fi
}

#Check if docker build was completed
build_docker_image () {
    build_docker
    if [ $? -eq 0 ]; then
        echo "Build executed, pushing the image to a Repository"
    else
        echo "Maven FAILED to compile, please check Jenkins errors"
        exit 1
    fi
}

#Push image to a repository, could be a Docker Hub or AWS ECR for example
push_docker_image () {
    docker push "{REPOSITORY}"
    if [ $? -eq 0 ]; then
        echo "Image pushed to Repository"
    else
        echo "push FAILED, please check Jenkins errors"
        exit 1
    fi
}

#############
### DEPLOY ###
#############

#To deploy image in an AWS ECS environment
deploy_docker_image () {
    sed -i "s/IMAGE_VERSION/${IMAGE_VERSION}/g" ./deploy/apirest.json

    TASK_DEFINITION=`aws ecs register-task-definition \
    --cli-input-json file://./deploy/apirest.json \
    --network-mode host \
    --profile "${AWS_PROFILE}" \
    | jq '.taskDefinition | .revision'`

#The parameters needs to be declared on Jenkins task
    aws ecs update-service \
    --cluster "${ECS_CLUSTER}" \
    --service "${ECS_SERVICE}" \
    --desired-count "${ECS_TASK_NUMBER}" \
    --task-definition "${ECS_SERVICE}":"${TASK_DEFINITION}" \
    --deployment-configuration maximumPercent="${MAXIMUM_PERCENT}",minimumHealthyPercent="${MINIMUM_HEALTH}" \
    --profile "${AWS_PROFILE}"
}

setting_variable
compile_docker_image
build_docker_image
push_docker_image
deploy_docker_image
       