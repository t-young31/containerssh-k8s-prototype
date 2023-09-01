output "ssh_command" {
  value = local.ssh_command
}

output "ssh_host" {
  value = "${local.ec2_username}@${aws_instance.server.public_ip}"
}

output "ssh_args" {
  value = local.ssh_args
}
