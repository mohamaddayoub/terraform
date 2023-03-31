#terraform_eks:

In this project I used Modules to build IaC on AWS.

❏ Created the VPC by using the VPC module with 6 subnets (3 private for worker nodes & 3 public for load balancers).
❏ Created the EKS cluster and worker nodes by using the EKS module.
❏ Configured Kubernetes provider to authenticate with K8s cluster.
❏ Applied configurations.
❏ Connect to the cluster locally by this command {aws eks update-kubeconfig --name CLUSTER_NAME --region REGION_NAME}
❏ Deployed nginx Application/Pod (deployment.yaml for nginx and service.yaml for load balancer).

The application is highly available (1 region 3 availability zone).
