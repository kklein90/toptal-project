Task details
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


## Terraform 
- VPC
- 3 subnets
- ECS cluster
- Task Definitions
- Cloudwatch logging
- ALB + target groups
- DB
  - backup

domain: toptal.internal
web - tcp:8081
api - tcp:8082
  