#!/bin/sh
sudo yum install unzip -y
mkdir -p /etc/systemd/system/
LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

# Install Nomad
curl https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip --output nomad.zip
unzip nomad.zip
mv nomad /usr/local/bin
mkdir /var/nomad
mkdir /etc/nomad.d

# Install Consul
curl https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_linux_amd64.zip --output consul.zip
unzip consul.zip
mv consul /usr/local/bin
mkdir /var/consul
mkdir /etc/consul.d

cat <<EOF > /etc/nomad.d/config.hcl
name = "worker"
data_dir  = "/var/lib/nomad"
region    = "us-west"
advertise {
  # Defaults to the first private IP address.
  http = "$LOCAL_IP"
  rpc  = "$LOCAL_IP"
  serf = "$LOCAL_IP" # non-default ports may be specified
}

client {
  enabled          = true
  server_join {
    retry_join = ["${nomad_address}"]
    retry_max = 3
    retry_interval = "15s"
  }
  options = {
    "driver.raw_exec.enable" = "1"
  }
}

consul {
  address             = "127.0.0.1:8500"
  server_service_name = "nomad"
  client_service_name = "nomad-client"
  auto_advertise      = true
  server_auto_join    = true
  client_auto_join    = true
  token = "${consul_nomad_client_token}"
}

vault {
  enabled = true
  address = "${vault_address}"
  token   = "${vault_token}"
}

acl {
  enabled = true
  token_ttl = "30s"
  policy_ttl = "60s"
}
EOF

cat <<EOF > /etc/consul.d/config.hcl
node_name = "nomad_worker"
data_dir  = "/var/lib/consul"
client_addr = "127.0.0.1"
datacenter = "us-west-2"
retry_join = ["provider=aws tag_key=aws:autoscaling:groupName tag_value=consul-demo"]
bind_addr = "$LOCAL_IP"
acl {
    tokens {
        agent = "${consul_client_token}"
    }
}
EOF

cat <<EOF > /etc/systemd/system/nomad.service
[Unit]
Description=Nomad service discovery agent
Requires=network-online.target
After=network.target

[Service]
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/nomad agent -config=/etc/nomad.d/config.hcl
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

service consul start
service nomad start