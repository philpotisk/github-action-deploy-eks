#!/bin/sh

echo "EKS Deloyment of ${CONTAINER_NAME}"

set -e

echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

IS_DEPLOYED=$(kubectl get deployments |grep ${CONTAINER_NAME})

echo ${CONTAINER_PATH}
cd ${CONTAINER_PATH}

ls -al

echo "$EXTERNAL_GIT_KEY" | base64 --decode > ./id_rsa
ssh-agent bash -c 'ssh-add ./id_rsa; git clone git@ec2-13-59-213-19.us-east-2.compute.amazonaws.com:/home/git/repo'

ls -al
#echo "Creating cluster (deployment-${CONTAINER_NAME}.yml) ..."
#kubectl create -f deployment-${CONTAINER_NAME}.yml
#kubectl create -f nodeport-${CONTAINER_NAME}.yml


if [ -z "${IS_DEPLOYED}" ]
then
   echo "Creating cluster (deployment-${CONTAINER_NAME}.yml) ..."
   kubectl create -f deployment-${CONTAINER_NAME}.yml
   kubectl create -f nodeport-${CONTAINER_NAME}.yml
else
   echo "Updating cluster ..."
   kubectl rollout restart -f deployment-${CONTAINER_NAME}.yml
fi
