FROM phil21/deploy-eks-base:1.0

LABEL "name"="Deploy to AWS EKS"
LABEL "maintainer"="Phil <philipp.potisk@danubetech.com>"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="GitHub Action for Docker"
LABEL "com.github.actions.description"="Wraps the Docker CLI to enable Docker commands."
LABEL "com.github.actions.icon"="package"
LABEL "com.github.actions.color"="blue"

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
