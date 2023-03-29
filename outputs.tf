output "ec2_public_ip" {
    value = module.devops_webserver.ec2_pub_ip.public_ip
}