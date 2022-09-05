resource "openstack_networking_port_v2" "vm_0" {
  name               = "exampleproject_dev_vm_0_port"
  network_id         = openstack_networking_network_v2.main.id
  admin_state_up     = true
  security_group_ids = [ openstack_networking_secgroup_v2.main.id ]
  fixed_ip {
    subnet_id  = openstack_networking_subnet_v2.main.id
    ip_address = "10.0.0.20"
  }
}

resource "openstack_blockstorage_volume_v3" "vm_0_system" {
  name        = "exampleproject_dev_vm_0_system"
  image_id    = data.openstack_images_image_v2.almalinux8.id
  description = "vm_0 system volume"
  enable_online_resize = true
  size        = 10
  volume_type = "hdd"
}

resource "openstack_compute_instance_v2" "vm_0" {
  name            = "exampleproject_dev_vm_0"
  # TODO: make link to flavors list in aitu.cloud 
  flavor_name     = "m5.medium"
  config_drive    = false

  key_pair        = openstack_compute_keypair_v2.admins_keypair.id
  user_data       = <<-EOT
  #cloud-config
  hostname: vm_0.some.domain
  fqdn: vm_0.some.domain
  EOT

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.vm_0_system.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = false
  }

  network {
    port = openstack_networking_port_v2.vm_0.id
  }
}

resource "openstack_networking_floatingip_v2" "vm_0" {
  pool      = data.openstack_networking_network_v2.ext.name
  subnet_id = data.openstack_networking_subnet_v2.ext.id
  port_id   = openstack_networking_port_v2.vm_0.id
}

output "vm_0_connect_via" {
  value = "ssh almalinux@${openstack_networking_floatingip_v2.vm_0.address}"
}
