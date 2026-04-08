#!/bin/bash
# all commands run as root b/c this file is run via cloud-init as user-data in AWS

LOG=/var/log/user-data-output.log

function ts() {
  date +"%D-%T"
}

echo "###############################################" | tee -a $LOG
echo "$(ts) - Bootstrap Log Start " | tee -a $LOG
echo "###############################################" | tee -a $LOG
echo "$(ts) - Installing Git & Ansible + Collections"
apt-get update
apt-get -y install jq git ansible awscli docker.io docker-compose

echo "$(ts) - Getting Github credentials from SecretsManager" | tee -a $LOG
aws --region us-east-1 ssm get-parameter --name /devops/github-key --output text --query Parameter.Value >>/home/admin/.ssh/github-runner-key
chmod 600 /home/admin/.ssh/github-runner-key && chown admin:admin /home/admin/.ssh/*

cat <<EOF >>/home/admin/.gitconfig:with
[user]
    email = kklein@gmail.com
    name = kklein90
EOF

cat <<EOF >>/home/admin/.ssh/config
Host github.com
  Hostname github.com
  StrictHostKeyChecking accept-new
  IdentityFile ~/.ssh/github-runner-key
EOF

# add admin to docker group
usermod -G docker admin

# clone the repo, cd into appropriate folder, pull .env from SSM for compose file 
echo "$(ts) - cloning git repo" | tee -a $LOG
cd /home/admin && sudo -H -u admin bash -c 'git clone git@github.com:kklein90/toptal-project.git'

echo "$(ts) - getting initial api env file from ssm" | tee -a $LOG
aws --region us-east-1 ssm get-parameters --with-decryption --names /app/api --query "Parameters[*].Value" --output text > /home/admin/toptal-project/node-3tier-app2/api/.env


echo "$(ts) - starting the api server" | tee -a $LOG
sudo -H -u admin bash -c 'docker-compose -f /home/admin/toptal-project/node-3tier-app2/api/docker-compose.yml up -d'