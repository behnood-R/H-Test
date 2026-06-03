resource "datadog_monitor" "alb_4xx_ratio" {
  name = "[${var.env}] High ALB 4xx ratio for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  The load balancer is seeing a spike in 4xx responses, which can indicate broken routing, auth issues, or client-visible request rejection.
  Check recent deploys, auth flows, and API contract changes.
  ${var.notification_target}
  EOT

  query = "avg(last_5m):100 * ((sum:aws.applicationelb.httpcode_elb_4xx{loadbalancer:${var.load_balancer_name}}.as_count() + sum:aws.applicationelb.httpcode_target_4xx{loadbalancer:${var.load_balancer_name}}.as_count()) / clamp_min(sum:aws.applicationelb.request_count{loadbalancer:${var.load_balancer_name}}.as_count(), 1)) > ${var.alb_4xx_critical_threshold}"

  monitor_thresholds {
    warning  = var.alb_4xx_warning_threshold
    critical = var.alb_4xx_critical_threshold
  }

  evaluation_delay  = 300
  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "alb_5xx_ratio" {
  name = "[${var.env}] High ALB 5xx ratio for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  The load balancer is seeing a spike in 5xx responses, indicating user-facing request failures.
  Check recent deploys, traces, downstream dependencies, and database behavior.
  ${var.notification_target}
  EOT

  query = "avg(last_5m):100 * ((sum:aws.applicationelb.httpcode_elb_5xx{loadbalancer:${var.load_balancer_name}}.as_count() + sum:aws.applicationelb.httpcode_target_5xx{loadbalancer:${var.load_balancer_name}}.as_count()) / clamp_min(sum:aws.applicationelb.request_count{loadbalancer:${var.load_balancer_name}}.as_count(), 1)) > ${var.alb_5xx_critical_threshold}"

  monitor_thresholds {
    warning  = var.alb_5xx_warning_threshold
    critical = var.alb_5xx_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "login_success_ratio" {
  name = "[${var.env}] Low login success ratio for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  User login success ratio has dropped below the expected baseline.
  Check authentication dependencies, application errors, and recent auth-related changes.
  ${var.notification_target}
  EOT

  query = "avg(last_10m):100 * (sum:${var.login_success_metric}{service:${var.service_name},env:${var.env}}.as_count() / clamp_min(sum:${var.login_attempt_metric}{service:${var.service_name},env:${var.env}}.as_count(), 1)) < ${var.login_success_ratio_critical_threshold}"

  monitor_thresholds {
    warning  = var.login_success_ratio_warning_threshold
    critical = var.login_success_ratio_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "transaction_success_ratio" {
  name = "[${var.env}] Low transaction request success ratio for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  Transaction request success ratio has dropped below the expected baseline.
  Check application errors, downstream dependencies, and any recent transaction-flow changes.
  ${var.notification_target}
  EOT

  query = "avg(last_10m):100 * (sum:${var.transaction_success_metric}{service:${var.service_name},env:${var.env}}.as_count() / clamp_min(sum:${var.transaction_attempt_metric}{service:${var.service_name},env:${var.env}}.as_count(), 1)) < ${var.transaction_success_ratio_critical_threshold}"

  monitor_thresholds {
    warning  = var.transaction_success_ratio_warning_threshold
    critical = var.transaction_success_ratio_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "request_latency_p95" {
  name = "[${var.env}] High p95 request latency for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  p95 latency is elevated for customer-facing requests.
  Check traces, slow endpoints, GraphQL resolvers, and database timings.
  ${var.notification_target}
  EOT

  query = "avg(last_10m):p95:${var.request_latency_metric}{service:${var.service_name},env:${var.env}} > ${var.p95_latency_critical_threshold_ms}"

  monitor_thresholds {
    warning  = var.p95_latency_warning_threshold_ms
    critical = var.p95_latency_critical_threshold_ms
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "request_latency_p99" {
  name = "[${var.env}] High p99 request latency for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  p99 latency is elevated for customer-facing requests.
  Check long-tail traces, slow endpoints, and database or dependency hotspots.
  ${var.notification_target}
  EOT

  query = "avg(last_10m):p99:${var.request_latency_metric}{service:${var.service_name},env:${var.env}} > ${var.p99_latency_critical_threshold_ms}"

  monitor_thresholds {
    warning  = var.p99_latency_warning_threshold_ms
    critical = var.p99_latency_critical_threshold_ms
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "pod_restart_rate" {
  name = "[${var.env}] Pod restart rate increase for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  Pod restarts have increased and may indicate crashing workloads or unstable dependencies.
  Check container logs, OOM kills, deployment health, and recent releases.
  ${var.notification_target}
  EOT

  query = "sum(last_15m):sum:kubernetes.containers.restarts{kube_namespace:${var.namespace},kube_deployment:${var.deployment_name},env:${var.env}}.as_count() > ${var.pod_restart_count_critical_threshold}"

  monitor_thresholds {
    critical = var.pod_restart_count_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "disk_available_storage" {
  name = "[${var.env}] Low available disk space for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  Available disk space is dropping into a dangerous range.
  Check node filesystem usage, log growth, temp-file buildup, and persistent volume pressure.
  ${var.notification_target}
  EOT

  query = "avg(last_15m):100 - (avg:system.disk.in_use{kube_cluster_name:${var.kube_cluster_name},env:${var.env}} * 100) < ${var.disk_free_critical_threshold_percent}"

  monitor_thresholds {
    critical = var.disk_free_critical_threshold_percent
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "rds_cpu" {
  name = "[${var.env}] High RDS CPU utilization for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  RDS CPU utilization is creeping up and may impact request latency and throughput.
  Check query load, deployment changes, and expensive transaction paths.
  ${var.notification_target}
  EOT

  query = "avg(last_15m):avg:aws.rds.cpuutilization{dbinstanceidentifier:${var.db_instance_identifier}} > ${var.rds_cpu_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_cpu_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}

resource "datadog_monitor" "rds_io_pressure" {
  name = "[${var.env}] High RDS I/O pressure for ${var.service_name}"
  type = "query alert"

  message = <<-EOT
  RDS disk queue depth is increasing and indicates sustained I/O pressure.
  Check slow queries, burst activity, and storage performance limits.
  ${var.notification_target}
  EOT

  query = "avg(last_15m):avg:aws.rds.disk_queue_depth{dbinstanceidentifier:${var.db_instance_identifier}} > ${var.rds_disk_queue_depth_critical_threshold}"

  monitor_thresholds {
    critical = var.rds_disk_queue_depth_critical_threshold
  }

  include_tags      = true
  notify_no_data    = false
  renotify_interval = 30
  tags              = local.tags
}
