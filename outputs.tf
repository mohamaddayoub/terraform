output "ec2_public_ip" {
    value = aws_instance.DevOps_SERVER.public_ip
}