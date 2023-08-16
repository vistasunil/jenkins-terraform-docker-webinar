terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

provider "docker" {
#  host = "tcp://localhost:2375"
}

resource "docker_image" "webapp" {
  name         = "cloudtrain:latest"
  build {
    path = "${path.cwd}/devopsIQ"
    no_cache = "true"
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "devopsIQ/*") : filesha1(f)]))
  }
#  keep_locally = false
}

resource "docker_container" "webapp" {
  image = docker_image.webapp.image_id
  name  = "cloudtrain"
  ports {
    internal = 80
    external = 8000
  }
}
