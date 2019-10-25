#!/bin/sh

echo "EKS Deloyment of ${CONTAINER_NAME}"

set -e

ls -al

echo "$EXTERNAL_GIT_KEY" | base64 --decode > ./id_rsa
chmod 400 ./id_rsa
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ssh-agent bash -c 'ssh-add ./id_rsa; git clone git@ec2-13-59-213-19.us-east-2.compute.amazonaws.com:/home/git/uniresolver-kubernetes'

cd ./uniresolver-kubernetes
ls -al

echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
kubectl version --client --short
echo "Checking deployment state of ${CONTAINER_NAME} ..."
IS_DEPLOYED=$(kubectl -n uni-resolver get deployments |grep ${CONTAINER_NAME})



#echo "Creating cluster (deployment-${CONTAINER_NAME}.yml) ..."
#kubectl create -f deployment-${CONTAINER_NAME}.yml
#kubectl create -f nodeport-${CONTAINER_NAME}.yml


if [ -z "${IS_DEPLOYED}" ]
then
   echo "Creating cluster (${CONTAINER_NAME}-deployment.yaml) ..."
   kubectl -n uni-resolver create -f ${CONTAINER_NAME}-deployment.yaml
   kubectl -n uni-resolver create -f ${CONTAINER_NAME}-service.yaml
else
   echo "Updating cluster ..."
   kubectl n uni-resolver rollout restart -f ${CONTAINER_NAME}-deployment.yaml
fi

kubectl n uni-resolver rollout restart -f uni-resolver-ingress.yaml