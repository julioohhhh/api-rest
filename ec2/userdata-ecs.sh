#!/bin/bash
cat << EOF > /etc/ecs/ecs.config
ECS_CLUSTER=apirest
ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1m
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs","syslog"]
EOF
docker run --name ecs-agent \
--detach=true \
--restart=on-failure:10 \
--volume=/var/run/docker.sock:/var/run/docker.sock \
--volume=/var/log/ecs/:/log \
--volume=/var/lib/ecs/data:/data \
--volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
--volume=/var/run/docker/execdriver/native:/var/lib/docker/execdriver/native:ro \
--env-file=/etc/ecs/ecs.config \
--env=ECS_LOGFILE=/log/ecs-agent.log \
--env=ECS_LOGLEVEL=info \
--env=ECS_DATADIR=/data \
amazon/amazon-ecs-agent:latest