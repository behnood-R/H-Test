Terraform

Build a Terraform module to deploy a simple containerized service to an AWS EKS Kubernetes cluster. Please include any requisite ancillary infrastructure, such as VPC, networking, or security. Please share your response in a public GitHub repository. Include a README with step-by-step instructions to deploy everything end-to-end. You can optionally include a brief (1-2 paragraph) explanation of any key design decisions, as well as a link to the deployed service or a screenshot of the service running.

Requirements (build this in Terraform)

1. AWS EKS Cluster
2. An application running (any application is fine. For example, a “hello world” or a basic React project ).
3. Cluster is not publicly exposed to the internet however can still pull from public repos (no internet gateway).
4. Ship it with some basic observability. You can use cloudwatch or for this.



Follow-up questions:
1. How would you expose this application to the internet without a public EKS endpoint?
2. Justify any security decisions or tradeoffs you made during this design.

   
To answer these questions, I have created the following resources in EKS, in addition to what is listed as requirements:
1. External-DNS, it helps to create a record per application in HostedZone on Route53.
2. AWS-LoadBalancer-Controller, it helps to expose the apps using the ALB as HTTPS connections ( encrypted connections) using AWS ACM.
3. The combination of both ExternalDNS and AWS-LoadBalancer-Controller helps to expose the application from inside the EKS on a private subnet securely.

I have tried to keep this setup simple to improve availability/reachability/security. The ALB could be created behind a CloudFront distribution, with a WAF ACL to add better protection, enabling rate limiting and more features on those layers.
