job "asciifier-service" {
  datacenters = ["dc1"]

  group "asciifier-service" {
    task "asciifier-service" {
      driver = "docker"
      config {
        image = "mnd22/asciifier-service:1.0.0"
        network_mode = "host"
        port_map {
          api = 8081
        }
      }

      env {
        app_bind = "0.0.0.0"
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
          name     = "alive"
          port     = "api"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}