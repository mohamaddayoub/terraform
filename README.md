#terraform_eks:

In this project I'v used Modules to build the infrastructure on AWS.

❏ Created the VPC by using the VPC module with 6 subnets (3 private for worker nodes & 3 public for load balancers).
❏ Created the EKS cluster and worker nodes by using the EKS module.
❏ Configured Kubernetes provider to authenticate with K8s cluster.
❏ Applied configurations.
❏ Connect to the cluster locally by this command {aws eks update-kubeconfig --name CLUSTER_NAME --region REGION_NAME}
❏ Deployed nginx Application/Pod (nginx-config.yaml).

This application is highly available (1 region - 3 availability zone).

Do not forget to destroy everything.
