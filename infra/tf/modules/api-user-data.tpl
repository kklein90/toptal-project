#!/bin/bash

function ts() {
  date +"%D-%T"
}

echo "###############################################" | tee -a $LOG
echo "$(ts) - Bootstrap Log Start " | tee -a $LOG
echo "###############################################" | tee -a $LOG
echo "$(ts) - Installing Git & Ansible + Collections"
apt-get update
apt-get -y install jq git ansible awscli docker.io docker-compose-plugin

echo "$(ts) - Getting Github credentials from SecretsManager" | tee -a $LOG
aws --region us-east-1 ssm get-parameter --name /devops/github-key --output text --query Parameter.Value >>~/.ssh/github-runner-key
chmod 600 ~/.ssh/github-runner-key

cat <<EOF >>~/.gitconfig:with
[user]
    email = kklein@gmail.com
    name = kklein90
EOF

cat <<EOF >>~/.ssh/config
Host github.com
  Hostname github.com
  StrictHostKeyChecking accept-new
  IdentityFile ~/.ssh/github-runner-key
EOF

echo "$(ts) - Cloning git repositories for Ansible code." | tee -a $LOG
# the GITUSER & GITPASS variables here are escaped with $$ to prevent TF interference
### git clone [[repo with the docker compose files]] or echo the compose files here


