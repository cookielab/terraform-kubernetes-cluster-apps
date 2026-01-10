module "grafana_alloy" {
  source = "../../"

  agent_name           = "node"
  agent_resources      = var.agent_resources
  clustering_enabled   = false
  chart_version        = var.chart_version
  controller_resources = var.controller_resources
  cluster_name         = var.cluster_name
  kubernetes_kind      = "daemonset"
  namespace            = var.namespace
  image                = var.image
  metrics              = var.metrics
  otel                 = var.otel
  pod_disruption_budget = var.pod_disruption_budget

  tolerations   = var.tolerations
  node_selector = var.node_selector
  integrations = {
    node_exporter = true
  }

  kubernetes_security_context = {
    runAsUser  = 0
    privileged = true
  }

  host_volumes = [
    {
      name       = "rootfs"
      host_path  = "/"
      mount_path = "/host/root"
    },
    {
      name       = "sysfs"
      host_path  = "/sys"
      mount_path = "/host/sys"
    },
    {
      name       = "procfs"
      host_path  = "/proc"
      mount_path = "/host/proc"
    },
  ]

  config = concat(var.config, [<<-EOF
    node_exporter "default" {
      scrape_interval = "${var.node_exporter.scrape_interval}"
      scrape_timeout  = "${var.node_exporter.scrape_timeout}"
      metrics_output  = prometheus.remote_write.default.receiver
    }
    EOF
    , var.otel.enabled ? <<-EOF
    otel_ingest "default" {
      metrics_output  = otelcol.exporter.otelhttp.default.receiver
      traces_output   = otelcol.exporter.otelhttp.default.receiver
    }
    EOF
    : ""
  ])
}
