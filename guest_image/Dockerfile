FROM containerssh/agent AS agent

FROM registry.access.redhat.com/ubi8/ubi:8.8-1032.1692772289
COPY --from=agent /usr/bin/containerssh-agent /usr/bin/containerssh-agent
