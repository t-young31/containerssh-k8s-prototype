# containerssh-k8s-prototype
> **Warning**
> Not production ready. Use at your own risk!

Prototype implementation of using [ContainerSSH](https://containerssh.io/)
with kubernetes for ephemeral container access.

## Usage

Create a `.env` file from `.env.sample` and set the required fields then run

```bash
(cd auth_server && make push)
# login to the AWS CLI with e.g. make login
make aws
make ssh
make contdssh
logout
ssh-keygen -t ed25519 -C "you@example.com" -f id_ed25519
ssh foo@_aws_host_ -p 2222 -i id_ed25519
```

> [!IMPORTANT]
> The package repository must allow public access. On GitHub navigate to
> `Package settings` and change the visibility
