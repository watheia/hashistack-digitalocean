job "age-generator" {

  datacenters = ["dc1"]

  type = "service"

  update {

    stagger      = "30s"

    max_parallel = 1

  }

  group "webs" {

    count = 1

    task "age-generator" {

      driver = "docker"

      config {
        image = "eschudt/age-generator:${version}"
        advertise_ipv6_address = false
        args = [
          "-bind", "${NOMAD_PORT_http}"
        ]
      }

      service {

        name = "age-generator"

        port = "http"

        tags = ["urlprefix-/ages strip=/ages"]

        check {
          type     = "http"
          name	   = "age-generator"
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
