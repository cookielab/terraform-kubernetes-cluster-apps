resource "kubernetes_config_map_v1" "grafana_alloy" {
  metadata {
    name      = format("%s-config", local.agent_name)
    namespace = var.namespace
  }

  data = {
    (local.agent_config_key) = join("\n", concat(
      flatten(var.default_config_enabled ? [
        [
          var.integrations.k8s_cadvisor ? file("${path.module}/templates/k8s_cadvisor.river.tmpl") : "",
          var.integrations.k8s_kubelet ? file("${path.module}/templates/k8s_kubelet.river.tmpl") : "",
          var.integrations.k8s_mimir_rules ? file("${path.module}/templates/k8s_mimir_rules.river.tmpl") : "",
          var.integrations.k8s_pods ? templatefile("${path.module}/templates/k8s_pods.river.tmpl", {
            scrape_pods_global     = var.k8s_pods.scrape_pods_global
            scrape_pods_annotation = var.k8s_pods.scrape_pods_annotation
          }) : "",
          var.integrations.k8s_services ? file("${path.module}/templates/k8s_services.river.tmpl") : "",
          var.integrations.node_exporter ? file("${path.module}/templates/node_exporter.river.tmpl") : "",
          var.integrations.aws_alb ? file("${path.module}/templates/aws_alb.river.tmpl") : "",
          var.integrations.aws_rds ? file("${path.module}/templates/aws_rds.river.tmpl") : "",
          var.integrations.aws_sqs ? file("${path.module}/templates/aws_sqs.river.tmpl") : "",
          var.integrations.aws_mq ? file("${path.module}/templates/aws_mq.river.tmpl") : "",
          var.integrations.aws_opensearch ? file("${path.module}/templates/aws_opensearch.river.tmpl") : "",
          var.integrations.remote_write_metrics ? templatefile("${path.module}/templates/remote_write_metrics.river.tmpl", {
            grafana_alloy_metrics_tenant = var.metrics.tenant
          }) : "",
          var.integrations.kafka_jmx_metrics ? templatefile("${path.module}/templates/kafka_jmx_metrics.river.tmpl", {
            addresses             = var.kafka_jmx_metrics.kafka_broker_list
            metrics_endpoint_path = var.kafka_jmx_metrics.metrics_endpoint_path
          }) : "",
          var.integrations.otel_collector ? templatefile("${path.module}/templates/otel_collector.river.tmpl", {
            otel_http_port                 = var.otel.http_port
            otel_grpc_port                 = var.otel.grpc_port
            otel_service_graphs_dimensions = var.otel.service_graphs_dimensions
          }) : "",
          var.integrations.loki_logs ? templatefile("${path.module}/templates/loki_pod_logs.river.tmpl", {
            scrape_pods_global     = var.loki.scrape_pods_global
            scrape_pods_annotation = var.loki.scrape_pods_annotation
            loki_auth_enabled      = var.loki.auth_enabled
            loki_tenant_id         = var.loki.tenant_id
            clustering_enabled     = var.clustering_enabled
            scrape_logs_method     = var.loki.scrape_logs_method
          }) : "",
        ],
      ] : []),
      flatten(var.config),
    ))
  }
}
