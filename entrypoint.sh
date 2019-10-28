#!/bin/sh

echo "EKS Deloyment of ${CONTAINER_NAME}"

set -e

ls -al

curl https://www.whatismyip.net/

echo "$EXTERNAL_GIT_KEY" | base64 --decode > ./id_rsa
chmod 400 ./id_rsa
export GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
ssh-agent bash -c 'ssh-add ./id_rsa; git clone ssh://git-read@11347-01.root.nessus.at:/var/git/universal-resolver-kubernetes.git'

cd ./universal-resolver-kubernetes
ls -al

echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

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
   kubectl -n uni-resolver rollout restart -f ${CONTAINER_NAME}-deployment.yaml
fi

kubectl -n uni-resolver apply -f uni-resolver-ingress.yaml