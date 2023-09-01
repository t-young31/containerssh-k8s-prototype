# containerssh-k8s-prototype
> **Warning**
> Not production ready. Use at your own risk!

Prototype implementation of using [ContainerSSH](https://containerssh.io/)
with kubernetes for ephemeral container access.

## Usage

```bash
# login to the AWS CLI with e.g. make login
make aws
make ssh
make contdssh
logout
ssh foo@_aws_host_ -p 2222
```
