job "asciifier-web" {
  datacenters = ["dc1"]

  group "asciifier-web" {
    task "asciifier-web" {
      driver = "docker"
      config {
        image = "mnd22/asciifier-web:1.0.0"
        network_mode = "host"
        port_map {
          api = 8080
        }
      }

      env {
        app_bind = "0.0.0.0"
      }

      template {
        destination   = "/local/config.json"
        change_mode   = "restart"
        data = <<EOH
{
  "asciifierUrl": "http://127.0.0.1:{{ env "NOMAD_PORT_proxy_tcp" }}"
}
        EOH
      }

      resources {
        cpu    = 500 # 500 MHz
        memory = 256 # 256MB
        network {
          mbits = 10
          port "api" { static = "8080" }
        }
      }

      service {
        name = "asciifier-web"
        port = "api"

        check {
          name     = "alive"
          port     = "api"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

    task "proxy" {
      driver = "raw_exec"

      config {
          command = "/usr/local/bin/consul"
          args    = [
              "connect", "proxy",
              "-service", "asciifier-web",
              "-upstream", "asciifier:${NOMAD_PORT_tcp}",
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