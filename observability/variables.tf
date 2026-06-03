variable "env" {
  description = "Environment tag, such as prod."
  type        = string
}

variable "service_name" {
  description = "Logical application service name."
  type        = string
}

variable "load_balancer_name" {
  description = "ALB name tag as reported by Datadog AWS integration."
  type        = string
}

variable "kube_cluster_name" {
  description = "Kubernetes cluster tag used on Datadog infra metrics."
  type        = string
}

variable "db_instance_identifier" {
  description = "RDS DB instance identifier."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for restart monitoring."
  type        = string
}

variable "deployment_name" {
  description = "Kubernetes deployment name for restart monitoring."
  type        = string
}

variable "notification_target" {
  description = "PagerDuty service, Slack channel, or Datadog handle."
  type        = string
  default     = "@pagerduty"
}

variable "login_success_metric" {
  description = "Custom business metric counting successful logins."
  type        = string
  default     = "app.auth.login.success"
}

variable "login_attempt_metric" {
  description = "Custom business metric counting login attempts."
  type        = string
  default     = "app.auth.login.attempt"
}

variable "transaction_success_metric" {
  description = "Custom business metric counting successful transaction requests."
  type        = string
  default     = "app.transaction.request.success"
}

variable "transaction_attempt_metric" {
  description = "Custom business metric counting total transaction requests."
  type        = string
  default     = "app.transaction.request.total"
}

variable "request_latency_metric" {
  description = "Distribution metric used for p95 and p99 request latency."
  type        = string
  default     = "app.http.request.duration_ms"
}

variable "alb_4xx_warning_threshold" {
  description = "Warn when the ALB 4xx ratio exceeds this percentage."
  type        = number
  default     = 3
}

variable "alb_4xx_critical_threshold" {
  description = "Critical when the ALB 4xx ratio exceeds this percentage."
  type        = number
  default     = 5
}

variable "alb_5xx_warning_threshold" {
  description = "Warn when the ALB 5xx ratio exceeds this percentage."
  type        = number
  default     = 1
}

variable "alb_5xx_critical_threshold" {
  description = "Critical when the ALB 5xx ratio exceeds this percentage."
  type        = number
  default     = 2
}

variable "login_success_ratio_warning_threshold" {
  description = "Warn when login success ratio drops below this percentage."
  type        = number
  default     = 98
}

variable "login_success_ratio_critical_threshold" {
  description = "Critical when login success ratio drops below this percentage."
  type        = number
  default     = 95
}

variable "transaction_success_ratio_warning_threshold" {
  description = "Warn when transaction request success ratio drops below this percentage."
  type        = number
  default     = 98
}

variable "transaction_success_ratio_critical_threshold" {
  description = "Critical when transaction request success ratio drops below this percentage."
  type        = number
  default     = 95
}

variable "p95_latency_warning_threshold_ms" {
  description = "Warn when p95 request latency exceeds this threshold in the request latency metric's unit."
  type        = number
  default     = 400
}

variable "p95_latency_critical_threshold_ms" {
  description = "Critical when p95 request latency exceeds this threshold in the request latency metric's unit."
  type        = number
  default     = 750
}

variable "p99_latency_warning_threshold_ms" {
  description = "Warn when p99 request latency exceeds this threshold in the request latency metric's unit."
  type        = number
  default     = 800
}

variable "p99_latency_critical_threshold_ms" {
  description = "Critical when p99 request latency exceeds this threshold in the request latency metric's unit."
  type        = number
  default     = 1500
}

variable "pod_restart_count_critical_threshold" {
  description = "Critical when pod/container restarts exceed this count during the evaluation window."
  type        = number
  default     = 3
}

variable "disk_free_critical_threshold_percent" {
  description = "Critical when free disk percentage drops below this threshold."
  type        = number
  default     = 15
}

variable "rds_cpu_critical_threshold" {
  description = "Critical when RDS CPU utilization exceeds this percentage."
  type        = number
  default     = 80
}

variable "rds_disk_queue_depth_critical_threshold" {
  description = "Critical when RDS disk queue depth indicates sustained I/O pressure."
  type        = number
  default     = 64
}
