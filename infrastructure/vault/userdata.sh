#!/bin/sh
sudo yum install unzip -y
mkdir -p /etc/systemd/system/
LOCAL_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

curl https://releases.hashicorp.com/vault/1.0.0-beta1/vault_1.0.0-beta1_linux_amd64.zip --output vault.zip
unzip vault.zip
mv vault /usr/local/bin
mkdir /var/vault
mkdir /etc/vault.d

curl https://releases.hashicorp.com/consul/1.4.0-rc1/consul_1.4.0-rc1_linux_amd64.zip --output consul.zip
unzip consul.zip
mv consul /usr/local/bin
mkdir /var/consul
mkdir /etc/consul.d

cat <<EOF > /etc/vault.d/config.hcl
storage "consul" {
  address = "127.0.0.1:8500"
  token   = "${consul_vault_server_token}"
}

ui = true
listener "tcp" {
  address     = "$LOCAL_IP:8200"
  tls_disable = 1
}
EOF

cat <<EOF > /etc/consul.d/config.hcl
node_name = "vault-server"
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

cat <<EOF > /etc/systemd/system/vault.service
[Unit]
Description=Vault service discovery agent
Requires=network-online.target
After=network.target

[Service]
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/vault server -config=/etc/vault.d
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
service vault start