job "asciifier-service" {
  datacenters = ["dc1"]

  group "asciifier-service" {
    task "asciifier-service" {
      driver = "docker"
      config {
        image = "mnd22/asciifier-service:1.0.1"
        network_mode = "host"
        port_map {
          api = 8081
        }
      }

      env {
        app_bind = "127.0.0.1"
      }

      vault {
        policies = ["asciifier-service-policy"]
        change_mode   = "restart"
      }

      template {
        destination   = "/local/config.json"
        change_mode   = "restart"
        data = <<EOH
{
  {{ with secret "database/creds/app_db_role" }}
  "username": "{{ .Data.username }}",
  "password": "{{ .Data.password }}"{{ end }},
  "dbEndpoint": "hashi-demo.cluster-cnbj2iintjtp.us-west-2.rds.amazonaws.com"
}
        EOH
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "api" { static = "8081" }
        }
      }

      service {
        name = "asciifier-service"
        port = "api"

        check {
          type     = "script"
          name     = "alive"
          command  = "curl"
          args     = ["http://127.0.0.1:8081/"]
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "connect-proxy" {
        driver = "raw_exec"

        config {
            command = "/usr/local/bin/consul"
            args    = [
                "connect", "proxy",
                "-service", "asciifier-service",
                "-service-addr", "127.0.0.1:8081",
                "-listen", ":${NOMAD_PORT_tcp}",
                "-register",
                "-token", "" // Figure out how to get from Vault
            ]
        }

        resources {
            network {
                port "tcp" {}
            }
        }
    }
  }
}