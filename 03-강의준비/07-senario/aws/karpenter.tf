# Karpenter EC2NodeClass and NodePool
################################################################################
# Karpenter
################################################################################
resource "kubectl_manifest" "karpenter_default_ec2_node_class" {
  yaml_body = <<YAML
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  role: "${module.eks_blueprints_addons.karpenter.node_iam_role_name}"
  amiFamily: Bottlerocket 
  securityGroupSelectorTerms:
  - tags:
      karpenter.sh/discovery: ${module.eks.cluster_name}
  subnetSelectorTerms:
  - tags:
      karpenter.sh/discovery: ${module.eks.cluster_name}
  tags:
    IntentLabel: apps
    KarpenterNodePoolName: default
    NodeType: default
    intent: apps
    karpenter.sh/discovery: ${module.eks.cluster_name}
    project: karpenter-blueprints
YAML
  depends_on = [
    module.eks.cluster,
    module.eks_blueprints_addons.karpenter,
  ]
}

resource "kubectl_manifest" "karpenter_default_node_pool" {
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: default 
spec:  
  template:
    metadata:
      labels:
        intent: apps
    spec:
      requirements:
        - key: kubernetes.io/arch
          operator: In
          values: ["amd64"]
        - key: "karpenter.k8s.aws/instance-category"
          operator: In
          values: ["t"]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot", "on-demand"]
      nodeClassRef:
        name: default
      kubelet:
        containerRuntime: containerd
        systemReserved:
          cpu: 100m
          memory: 100Mi
  disruption:
    consolidationPolicy: WhenUnderutilized
    expireAfter: 720h

YAML
  depends_on = [
    module.eks.cluster,
    module.eks_blueprints_addons.karpenter,
    kubectl_manifest.karpenter_default_node_pool,
  ]
}
