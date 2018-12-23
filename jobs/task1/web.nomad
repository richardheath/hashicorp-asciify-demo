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
        data = <<TEMPLATE
{
  "asciifierUrl": "http://{{ range service "asciifier" }}{{ .Address }}:{{ .Port }}{{ end }}"
}
        TEMPLATE
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

    
  }
}