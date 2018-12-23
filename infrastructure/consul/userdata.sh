#!/bin/sh

curl https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_linux_amd64.zip --output consul.zip
unzip consul.zip
mv consul /usr/local/bin
mkdir /var/consul
mkdir /etc/consul.d

cat <<EOF > /etc/consul.d/config.hcl
primary_datacenter = "us-west-2"
acl {
  enabled = true
  default_policy = "deny"
  down_policy = "extend-cache"
  tokens {
    master = "temptoken"
    agent = "e6b08154-6899-3acf-3494-479e7d7e8b55"
  }
}

connect {
    enabled = true
}
EOF

cat <<EOF > /etc/systemd/system/consul.service
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent -server -data-dir=/tmp/consul -config-dir=/etc/consul.d -client=0.0.0.0 -datacenter=us-west-2 -bootstrap-expect=3 -ui -retry-join \"provider=aws tag_key=aws:autoscaling:groupName tag_value=consul-demo\"
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

service consul start