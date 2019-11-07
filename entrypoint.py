#!/usr/bin/env python3
#export CONTAINER_TAGS='universalresolver/driver-did-btcr:latest;universalresolver/driver-did-sov:latest;universalresolver/driver-did-erc725:latest'
import os, subprocess
tags = os.environ.get('CONTAINER_TAGS')
print("Deploying containers: " + str(tags))


def deployEks(containerName, deploymentFile):
   print('Deploying: ' + deploymentFile)
   try:
      ret = subprocess.check_output('kubectl -n uni-resolver get deployments |grep %s' % containerName, shell=True)
    
      if (containerName in ret):
         print('update ...')
         #kubectl -n uni-resolver rollout restart -f ${CONTAINER_NAME}-deployment.yaml
      else:
         print('create ...')
         #kubectl -n uni-resolver create -f ${CONTAINER_NAME}-deployment.yaml
   except subprocess.CalledProcessError as grepexc: 
      print('Error connecting to EKS cluster')

 

tags = os.environ['CONTAINER_TAGS']

for containterTag in tags.split(';'):
   user,containerNameVersion = containterTag.split('/')
   containerName, containerVersion = containerNameVersion.split(':')
   fin = open("deployment.yaml-template", "rt")
   deploymentFile = "deployment-%s.yaml" % containerName
   fout = open(deploymentFile, "wt")
   print('Writing file: ' + deploymentFile + ' for containter: ' + containterTag)
   for line in fin:
      fout.write(line.replace('{containerName}', containerName).replace('{containterTag}', containterTag))
   deployEks(containerName, deploymentFile)
	
fin.close()
fout.close()

#kubectl -n uni-resolver apply -f uni-resolver-ingress.yaml