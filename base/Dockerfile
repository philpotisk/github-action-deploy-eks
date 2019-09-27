FROM bitnami/minideb:latest

LABEL "name"="Deploy to AWS EKS"
LABEL "maintainer"="Phil <philipp.potisk@danubetech.com>"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="GitHub Action for Docker"
LABEL "com.github.actions.description"="Wraps the Docker CLI to enable Docker commands."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

RUN apt-get update -y && \
    apt-get install -y curl gnupg && \
    curl -Lso /bin/aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x /bin/aws-iam-authenticator && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    apt-get -y clean && apt-get -y autoclean && apt-get -y autoremove && \
    apt-get install -y python3 && \
    apt install -y python3-pip && \
    pip3 install --upgrade pip && \
    pip3 install setuptools awscli
