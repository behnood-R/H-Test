Observability

Describe the observability setup you’d configure for our platform. We’re especially interested in what you’d consider the most important monitors and alerts to set up. Please identify which alerts you’d consider to be crucial and which you’d mark with critical severity if triggered.

Provide the infrastructure-as-code configuration for the top 3-5 most important alerts. Please post this in a public GitHub repo and link it below.

On the Observability setup, I prefer to design it like the structure below:

1. Datadog Agent as a DaemonSet for infrastructure metrics created in EKS (EKS metrics)
2. The DB metrics (RDS)
3. App's metrics (Elixir monolith)
4. ALB/Routing services metrics


In this setup, the crucial metrics are the ones that show the end-to-end service health metrics such as:
1. ALB request drops ( spikes on 5xx & 4xx).
2. User's login success ratio.
3. transaction request ratio.
4. p95 & p99


The Critical metrics in this case will be:
1. Pod restart rate increase.
2. Dropping disk available storage space.
3. creeping up the RDS CPU & I/O.


I have used AI agents to convert my own observability structure into Terraform code. It could be optimized using best practices, including Terraform modules and separating metrics for app side and infrastructure environments.
