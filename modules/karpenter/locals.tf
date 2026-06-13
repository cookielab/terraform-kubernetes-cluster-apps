locals {
  # Karpenter chart defaults for settings.featureGates (chart 1.11.x).
  karpenter_feature_gates = {
    nodeRepair              = coalesce(var.feature_gates.node_repair, false)
    nodeOverlay             = coalesce(var.feature_gates.node_overlay, false)
    reservedCapacity        = coalesce(var.feature_gates.reserved_capacity, true)
    spotToSpotConsolidation = coalesce(var.feature_gates.spot_to_spot_consolidation, var.spot_to_spot_consolidation)
    staticCapacity          = coalesce(var.feature_gates.static_capacity, false)
  }
}
