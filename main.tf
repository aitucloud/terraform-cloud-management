provider "openstack" {
  # user_name taken from OS_USERNAME environment variable
  # password  taken from OS_PASSWORD environment variable
  auth_url    = "https://keystone.qshy.aitu.cloud:5000/v3/"
  domain_name = "Public"
  # tenant_name taken from OS_PROJECT_NAME environment variable
  #tenant_name = "exampleproject"
  # Also all env vars can be sourced from OpenStack RC File from ui.aitu.cloud
}

locals {
}

resource "openstack_compute_keypair_v2" "admins_keypair" {
  name = "admins_keypair"
  public_key = <<-EOT
  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhnoQF3CcZdgHpPiAMZu847sDnQlIikQeshMQmhD60U admin@hostname
  EOT
}

data "openstack_images_image_v2" "almalinux8" {
  name        = "AlmaLinux-8-GenericCloud-8.6-20220718.x86_64"
  most_recent = true
}

data "openstack_images_image_v2" "centos7" {
  name        = "CentOS-7-x86_64-GenericCloud-2003"
  most_recent = true
}

data "openstack_images_image_v2" "centosstream8" {
  name        = "CentOS-Stream-GenericCloud-8-20220125.1.x86_64"
  most_recent = true
}

data "openstack_images_image_v2" "ubuntu2204" {
  name        = "ubuntu-22.04-jammy-server-cloudimg-amd64"
  most_recent = true
}

## This resource is used to download custom image
#resource "openstack_images_image_v2" "image_name" {
#  name             = "Image Name"
#  image_source_url = "http://example.com/sample-image.qcow2"
#  container_format = "bare"
#  disk_format      = "qcow2"
#  min_disk_gb      = 10
#  web_download     = true
#}
