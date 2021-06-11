include {
  path = "${find_in_parent_folders()}"
}

terraform {
  source = "github.com/terraform-aws-modules/terraform-aws-eks?ref=master"

  after_hook "kubeconfig" {
    commands = ["apply"]
    execute  = ["bash", "-c", "terraform output --raw kubeconfig 2>/dev/null > ${get_terragrunt_dir()}/kubeconfig"]
  }

  after_hook "kubeconfig-tg" {
    commands = ["apply"]
    execute  = ["bash", "-c", "terraform output --raw kubeconfig 2>/dev/null > kubeconfig"]
  }

  after_hook "kube-system-label" {
    commands = ["apply"]
    execute  = ["bash", "-c", "kubectl --kubeconfig kubeconfig label ns kube-system name=kube-system --overwrite"]
  }

  after_hook "undefault-gp2" {
    commands = ["apply"]
    execute  = ["bash", "-c", "kubectl --kubeconfig kubeconfig patch storageclass gp2 -p '{\"metadata\": {\"annotations\":{\"storageclass.kubernetes.io/is-default-class\":\"false\"}}}'"]
  }
}

locals {
  aws_region = yamldecode(file("${find_in_parent_folders("region_values.yaml")}"))["aws_region"]
  env        = yamldecode(file("${find_in_parent_folders("env_tags.yaml")}"))["Env"]
  prefix     = yamldecode(file("${find_in_parent_folders("global_values.yaml")}"))["prefix"]
  name       = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["name"]
  custom_tags = merge(
    yamldecode(file("${find_in_parent_folders("global_tags.yaml")}")),
    yamldecode(file("${find_in_parent_folders("env_tags.yaml")}"))
  )
  //eks
  cluster_name = "${local.prefix}-${local.env}-${local.name}"
  vpc_id = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["vpc_id"]
  private_subnets = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["private_subnets"]
  //worker node
  worker_node_type = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["worker_node_type"]
  worker_node_max  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["worker_node_max"]
  worker_node_min  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["worker_node_min"]
  worker_node_desire = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["worker_node_desire"]
  //devops node
  devops_node_type = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["devops_node_type"]
  devops_node_max  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["devops_node_max"]
  devops_node_min  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["devops_node_min"]
  devops_node_desire = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["devops_node_desire"]
  //edge node
  edge_node_type = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["edge_node_type"]
  edge_node_max  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["edge_node_max"]
  edge_node_min  = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["edge_node_min"]
  edge_node_desire = yamldecode(file("${find_in_parent_folders("cluster_values.yaml")}"))["edge_node_desire"]
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<-EOF
    provider "aws" {
      region = "${local.aws_region}"
    }
    provider "kubernetes" {
      host                   = data.aws_eks_cluster.cluster.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
      token                  = data.aws_eks_cluster_auth.cluster.token
    }
    data "aws_eks_cluster" "cluster" {
      name = aws_eks_cluster.this[0].id
    }
    data "aws_eks_cluster_auth" "cluster" {
      name = aws_eks_cluster.this[0].id
    }
  EOF
}

inputs = {

  aws = {
    "region" = local.aws_region
  }

  tags = merge(
    local.custom_tags
  )

  cluster_name                         = local.cluster_name
  //todo
  subnets                              = local.private_subnets
  vpc_id                               = local.vpc_id
  write_kubeconfig                     = true
  enable_irsa                          = true
  kubeconfig_aws_authenticator_command = "aws"
  kubeconfig_aws_authenticator_command_args = [
    "eks",
    "get-token",
    "--cluster-name",
    local.cluster_name
  ]
  kubeconfig_aws_authenticator_additional_args = []

  cluster_version           = "1.20"
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  node_groups = {
    "${local.cluster_name}-managed-edge-node-group" = {
      create_launch_template = true
      desired_capacity       = local.edge_node_desire
      max_capacity           = local.edge_node_max
      min_capacity           = local.edge_node_min
      instance_types         = ["${local.edge_node_type}"]
      disk_size              = 100
      kubelet_extra_args     = "--register-with-taints=edgenode=true:NoSchedule"
      k8s_labels = {
        pool = "edge"
        department	= "monix"
        dedicated	= "edgenode"
        edgenode= "true"
        env= "nonprod"
      }
      capacity_type = "SPOT"
    }

    "${local.cluster_name}-managed-devops-node-group" = {
      create_launch_template = true
      desired_capacity       = local.devops_node_desire
      max_capacity           = local.devops_node_max
      min_capacity           = local.devops_node_min
      instance_types         = ["${local.devops_node_type}"]
      disk_size              = 100
      kubelet_extra_args     = ""
      k8s_labels = {
        pool = "devops"
        dedicated	= "app"
        department = "monix-devops"
        env= "nonprod"
      }
      capacity_type = "SPOT"
    }

    "${local.cluster_name}-managed-worker-node-group" = {
      create_launch_template = true
      desired_capacity       = local.worker_node_desire
      max_capacity           = local.worker_node_max
      min_capacity           = local.worker_node_min
      instance_types         = ["${local.worker_node_type}"]
      disk_size              = 100
      kubelet_extra_args     = ""
      k8s_labels = {
        pool = "woker"
        department	= "monix-common"
        dedicated	= "app"
        env= "nonprod"
      }
      capacity_type = "SPOT"
    }
  }
}
