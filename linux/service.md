## systemd, init — systemd system and service manager

### Concepts

systemd provides a dependency system between various entities called "units" of 12 different types. Units encapsulate various objects that are relevant for system boot-up and maintenance. The majority of units are configured in unit configuration files, whose syntax and basic set of options is described in systemd.unit(5), however some are created automatically from other configuration, dynamically from system state or programmatically at runtime.

Units may be "active" (meaning started, bound, plugged in, ..., depending on the unit type, see below), or "inactive" (meaning stopped, unbound, unplugged, ...), as well as in the process of being activated or deactivated, i.e. between the two states (these states are called "activating", "deactivating"). A special "failed" state is available as well, which is very similar to "inactive" and is entered when the service failed in some way (process returned error code on exit, or crashed, or an operation timed out). If this state is entered, the cause will be logged, for later reference.

Note that the various unit types may have a number of additional substates, which are mapped to the five generalized unit states described here.

`/usr/lib/systemd/systemd`

### list running service (interactive)
`systemctl`

### list systemd unit file

`systemctl list-unit-files`
`systemctl list-unit-files | grep docker`

### list service with different statueses

```
systemctl list-units -all --state=inactive
systemctl list-units -all --state=failed

active
inactive
activating
deactivating
failed

not-found
dead

```


### check service status and detail
`systemctl status service-name`

```
docker.service - Docker Application Container Engine
   Loaded: loaded (/usr/lib/systemd/system/docker.service; enabled; vendor preset: disabled)
   Active: active (running) since Thu 2022-10-06 15:42:07 UTC; 6h ago
     Docs: https://docs.docker.com
 Main PID: 4715 (dockerd)
    Tasks: 31
   Memory: 6.6G
   CGroup: /system.slice/docker.service
           └─4715 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

Loaded file => service definition file
`/usr/lib/systemd/system/docker.service`

### service directory
`/usr/lib/systemd/system/<service-name>`

cat to see content

```
[Unit]
Description=Docker Application Container Engine
Documentation=https://docs.docker.com
BindsTo=containerd.service
After=network-online.target docker.socket firewalld.service containerd.service
Wants=network-online.target
Requires=docker.socket

[Service]
Type=notify
EnvironmentFile=-/etc/sysconfig/docker
EnvironmentFile=-/etc/sysconfig/docker-storage
EnvironmentFile=-/run/docker/runtimes.env
ExecStartPre=/bin/mkdir -p /run/docker
ExecStartPre=/usr/libexec/docker/docker-setup-runtimes.sh
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
ExecStart=/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock $OPTIONS $DOCKER_STORAGE_OPTIONS $DOCKER_ADD_RUNTIMES
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=infinity
# Having non-zero Limit*s causes performance problems due to accounting overhead
# in the kernel. We recommend using cgroups to do container-local accounting.
LimitNPROC=infinity
LimitCORE=infinity
# Uncomment TasksMax if your systemd version supports it.
# Only systemd 226 and above support this version.
#TasksMax=infinity
TimeoutStartSec=0
# set delegate yes so that systemd does not reset the cgroups of docker containers
Delegate=yes
# kill only the docker process, not all processes in the cgroup
KillMode=process
# restart the docker process if it exits prematurely
RestartSec=2
Restart=always
StartLimitBurst=3
StartLimitInterval=60s

[Install]
WantedBy=multi-user.target
```

### How to register/enable unit

- Put unit file in to `/usr/lib/systemd/system/service-name`
- Run `sudo systemctl daemon-reload` to detect new unit
- Run `sudo systemctl enable docker-private-registry.service`
- Run `sudo systemctl start docker-private-registry.service`
- Run `sudo systemctl restart docker-private-registry.service` to restart failed unit

### How to debug / see logs of unit

`journalctl -u <unit-name>` # interactive mode from origin to latest (top down)

`journalctl -u <unit-name> --no-pager > log-1.txt` # dump log to file

`journalctl --since "2018-08-30 14:10:10" --until "2018-09-02 12:05:50"` filter by time

`journalctl -r` reverse

https://www.linode.com/docs/guides/how-to-use-journalctl/

