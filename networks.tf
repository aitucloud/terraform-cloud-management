data "openstack_networking_network_v2" "ext" {
  name = "qshyospubliccloud"
}

data "openstack_networking_subnet_v2" "ext" {
  name = "qshyospubliccloud"
}

resource "openstack_networking_router_v2" "router" {
  name                = "exampleproject_dev_router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.ext.id
}

resource "openstack_networking_network_v2" "main" {
  name           = "exampleproject_dev_network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "main" {
  name = "exampleproject_dev_subnet"
  network_id = openstack_networking_network_v2.main.id
  cidr       = "10.0.0.0/24"
  ip_version = 4
  enable_dhcp = true
  dns_nameservers = [ "8.8.8.8", "1.1.1.1" ]
  allocation_pool {
    start = "10.0.0.10"
    end   = "10.0.0.100"
  }
}

resource "openstack_networking_router_interface_v2" "mainri" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.main.id
}

resource "openstack_networking_secgroup_v2" "main" {
  name                 = "exampleproject_dev_secgroup"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.main.id
}

resource "openstack_networking_secgroup_rule_v2" "icmp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = openstack_networking_secgroup_v2.main.id
}

resource "openstack_networking_secgroup_rule_v2" "ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.main.id
}
