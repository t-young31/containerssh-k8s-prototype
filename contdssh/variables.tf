variable "auth_server_image" {
  type = string
  description = "Full path to the continer image e.g. ghcr.io/octo-cat/repo-name/auth_server"
}

variable "guest_image" {
  type = string
  description = "Image URI to pull for the guest container e.g. ghcr.io/octo-cat/repo-name/guest_image"
  default = "containerssh/containerssh-guest-image"
}
