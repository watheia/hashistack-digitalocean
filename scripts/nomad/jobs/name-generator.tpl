job "name-generator" {

  datacenters = ["dc1"]

  type = "service"

  update {

    stagger      = "30s"

    max_parallel = 1

  }

  group "webs" {

    count = 1

    task "name-generator" {

      driver = "docker"

      config {
        image = "eschudt/name-generator:${version}"
        advertise_ipv6_address = false
        args = [
          "-bind", "${NOMAD_PORT_http}",
        ]
      }

      env {
        "CONSUL_HTTP_ADDR" = "http://172.17.0.1:8500"
      }

      service {

        name = "name-generator"

        port = "http"

        tags = ["urlprefix-/names strip=/names"]

        check {
          type     = "http"
          name	   = "name-generator"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu    = 500 # MHz
        memory = 128 # MB

        network {
          mbits = 1
          port "http" {}
          port "https" {
            static = 443
          }
        }
      }
    }
  }
}