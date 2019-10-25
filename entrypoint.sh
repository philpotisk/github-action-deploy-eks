#!/bin/sh

echo "EKS Deloyment of ${CONTAINER_NAME}"

set -e

ls -al

echo "$EXTERNAL_GIT_KEY" | base64 --decode > ./id_rsa
chmod 400 ./id_rsa
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ssh-agent bash -c 'ssh-add ./id_rsa; git clone git@ec2-13-59-213-19.us-east-2.compute.amazonaws.com:/home/git/repo'

ls -al


echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

IS_DEPLOYED=$(kubectl get deployments |grep ${CONTAINER_NAME})

echo ${CONTAINER_PATH}
cd ${CONTAINER_PATH}
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
