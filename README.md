# Overview

This is a simple script that can be executed at the start time of linux
so save some instance specific data into a config file. This file
can then be read by applications to obtaine instance details. Currently
the following values are exported into a yaml file

- hostname
- public_ip
- private_ip
- instance_id (only availble for AWS servers)
- instance_type (only availble for AWS servers)

Te cofig file will be saved under the following path
`bash /etc/linux-hostinfo/hostinfo.yaml`

```yaml
instance_id: $instance_id
provider: $provider
hostname: $hostname
public_ip: $ip_addr
private_ip: $private_ip
```

This has been tested only on Ubuntu 20.04 but should work for other distros as
well.

# Installation

For easy installation you can call the isntall script. It will copy the main
script to `/usr/local/bin/linux-hostinfo.sh` and make it executable. Then
it will setup a systemd service to start the script at boot time

```bash
curl -sSL {https://raw.githubusercontent.com/thomaskhub/linux-hostinfo/main/install.sh} | sudo bash
```

# TODO:

If we want that this also runs with linode servers we need to setup a service
which can querry the Linode api using the ip address of the system to determine
the instance id. Instance id is only populated for AWS servers as of now.
