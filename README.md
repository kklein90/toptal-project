# TopTal project
## Task details
You want to design a continuous delivery architecture for a scalable and secure 3-tier Node application.

Application to use can be found at https://git.toptal.com/henrique/node-3tier-app2

Both web and API tiers should be exposed to the Internet and the DB tier should not be accessible from the Internet.



You should clone the repository and use it as the base for your system.

You need to create resources for all the tiers.
The architecture should be completely provisioned via some infrastructure as a code tool.
The presented solution must handle server (instance) failures.
Components must be updated without downtime in service.
The deployment of new code should be completely automated (bonus points if you create tests and include them in the pipeline).
The database and any mutable storage need to be backed up at least daily.
All relevant logs for all tiers need to be easily accessible (having them on the hosts is not an option).
You should fork the repository and use it as the base for your system.
You should be able to deploy it on one larger Cloud provider: AWS/Google Cloud/Azure/DigitalOcean/RackSpace.
The system should present relevant historical metrics to spot and debug bottlenecks.
The system should implement CDN to allow content distribution based on client location.


As a solution, please commit to the Toptal git repo the following:

An architectural diagram / PPT to explain your architecture during the interview.
All the relevant configuration scripts (Terraform/Ansible/Cloud Formation/ARM Templates)
All the relevant runtime handling scripts (start/stop/scale nodes).
All the relevant backup scripts.
You can use another git provider to leverage hooks, CI/CD, or other features not enabled in Toptal's git. Everything else, including the code for the CI/CD pipeline, must be pushed to Toptal's git.


## Solution
### General
I made slight modifications to the application code base:
- added a health check endpoint (/healthz) to the web app
### Access
The project is accessible at (my personal domain):
- http://api.kwkc.xyz
- http://web.kwkc.xyz

### Terraform
- VPC
  - internet gateway
  - nat gateway
  - route tables
- 4 subnets - 2 private for DB & 2 public for internet access
- ECS cluster
  - 2 services - app & web
  - Task Definitions - 1 each api & web
- Cloudwatch log groups
  - 1 each, api & web
- ALB + target groups
- WAF - regional & associated with the ALB
  - WAF rules
- IAM roles for launching and running ECS tasks
- CloudMap service discovery
  - private DNS zone - toptal.internal
- multiple security groups 
- SSM paramters (encrypted) for sensitive API environment variables
- DB
  - backup
- SecretsManager secrert for DB credentials
- Cloudflare DNS records for public access
- Cloudflare cache for CDN functionality

### CI/CD
This is implemented in Github Workflows/Actions:
- executes on Github hosted runners
- includes basic smoke tests
- includes required secrets to:
  - credentials for Docker Hub for image storage & retrieval
  - credentials for AWS to deploy ECS tasks
  