locals {
  ec2_username = "ec2-user"
  ssh_key_name = "ec2_id_rsa"

  k3s_version = "v1.27.3+k3s1"

  ssh_args    = "-i ${local.ssh_key_name}"
  ssh_command = "ssh ${local.ssh_args} ${local.ec2_username}@${aws_instance.server.public_ip}"

  tags = {
    Repo  = "containerssh-k8s-prototype"
    Owner = data.aws_caller_identity.current.arn
  }
}
