#!/bin/bash

###############
# CREATE EC2  #
###############

launch_ec2_spot_instances () {
    user_data="$(cat ec2/userdata.sh | base64 -w 0)"
    aws ec2 request-spot-instances \
    --spot-price "${SPOT_PRICE}" \
    --instance-count "${EC2_COUNT}" \
    --type "${TYPE}" \
    --instance-interruption-behavior "${BEHAVIOR}" \
    --profile ${AWS_PROFILE} \
    --launch-specification \
    "{ \
    \"ImageId\":\"${IMAGE_ID}\", \
       \"InstanceType\":\"${INSTANCE_TYPE}\", \
       \"KeyName\":\"${KEY_PAIR}\", \
       \"SubnetId\":\"${SUBNET_ID}\", \
       \"SecurityGroupIds\": [\"${SG_ID}\"], \
       \"UserData\":\"$user_data\", \
       \"Placement\": {
          \"AvailabilityZone\":\"${AZ}\"
       }, \
       \"IamInstanceProfile\": {
           \"Arn\":\"arn:aws:iam::${AWS_ORG_ID}:instance-profile/"${INSTANCE_PROFILE}"\"
       } \
    }"
}

launch_ec2_spot_instances