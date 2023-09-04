# containerssh-k8s-prototype
> **Warning**
> Not production ready. Use at your own risk!

Prototype implementation of using [ContainerSSH](https://containerssh.io/)
with kubernetes for ephemeral container access.

## Usage

Create a `.env` file from `.env.sample` and set the required fields, create a key pair
```bash
ssh-keygen -t ed25519 -C "foo@example.com" -f id_foo
cat id_foo.pub >> contdssh/authorized_keys
```

then deploy the prototype infrastructure in AWS/k8s
```bash
(cd auth_server && make push)
# login to the AWS CLI with e.g. make login
make aws
make ssh
cloud-init status --wait
make contdssh
# ensure pods are up with: kubectl get pods -n containerssh
```

finally, login to a container with
```bash
ssh foo@localhost -p 2222 -i id_foo
```


> [!IMPORTANT]
> The package repository must allow public access. On GitHub navigate to
> `Package settings` and change the visibility
