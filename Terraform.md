Terraform

Build a Terraform module to deploy a simple containerized service to an AWS EKS Kubernetes cluster. Please include any requisite ancillary infrastructure, such as VPC, networking, or security. Please share your response in a public GitHub repository. Include a README with step-by-step instructions to deploy everything end-to-end. You can optionally include a brief (1-2 paragraph) explanation of any key design decisions, as well as a link to the deployed service or a screenshot of the service running.



Requirements (build this in terraform)





AWS EKS Cluster



An application running (any application is fine. For example, a “hello world” or a basic react project ).



Cluster is not publicly exposed to the internet however can still pull from public repos (no internet gateway).



Ship it with some basic observability. You can use cloudwatch or for this.



Follow up questions:





How would you expose this application to the internet without a public EKS endpoint?





Justify any security decisions or tradeoffs you made during this design.
