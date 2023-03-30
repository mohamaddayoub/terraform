provider "kubernetes" {
    host = module.myapp_eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.myapp_eks.cluster_certificate_authority_data)
    exec {
        api_version = "client.authentication.k8s.io/v1beta1"
        command = "aws" 
        args = ["eks", "get-token", "--cluster-name", module.myapp_eks.cluster_name]
    }
}


module "myapp_eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name = "myapp_eks_cluster"
  cluster_version = "1.24"
  cluster_endpoint_public_access  = true

  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id = module.myapp_vpc.vpc_id
  subnet_ids = module.myapp_vpc.private_subnets

  tags = {
    environment = "development"
    application = "myapp"

  }

  self_managed_node_groups = {
    one = {
      name         = "worker-node-1"
      max_size     = 2
      desired_size = 1

      use_mixed_instances_policy = true
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity = 0
          on_demand_percentage_above_base_capacity = 10
          spot_allocation_strategy = "capacity-optimized"
        }

        override = [
          {
            instance_type     = "m5.large"
            weighted_capacity = "1"
          }
        ]
      }
    }
  }
}