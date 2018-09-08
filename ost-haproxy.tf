# Configure the OpenStack Provider
provider "openstack" {}

##----------------------------< network_1 create >----------------------------##
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}



##----------------------------< Create a subnet and attach to network_1 >----------------------------##
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = "${openstack_networking_network_v2.network_1.id}"
  cidr       = "10.1.1.0/24"
  ip_version = 4
  dns_nameservers = ["1.1.1.1"]
}

##----------------------------< router create >----------------------------##
resource "openstack_networking_router_v2" "R-HA" {
  name                = "R-HA"
  admin_state_up      = true
  external_network_id = "893a5b59-081a-4e3a-ac50-1e54e262c3fa"
}

##----------------------------< attach R1 to network_1 >----------------------------##
resource "openstack_networking_router_interface_v2" "router_interface_1" {
  router_id = "${openstack_networking_router_v2.R-HA.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_1.id}"
}

##----------------------------< create ports and attach to network_1 >----------------------------##
resource "openstack_networking_port_v2" "port_1" {
  name               = "port_1"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]
  
  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.11"
  }
}

resource "openstack_networking_port_v2" "port_2" {
  name               = "port_2"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.12"
  }
}

resource "openstack_networking_port_v2" "port_3" {
  name               = "port_3"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.13"
  }
}

resource "openstack_networking_port_v2" "port_4" {
  name               = "port_4"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.14"
  }
}

resource "openstack_networking_port_v2" "port_5" {
  name               = "port_5"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.15"
  }
}

resource "openstack_networking_port_v2" "port_6" {
  name               = "port_6"
  network_id         = "${openstack_networking_network_v2.network_1.id}"
  admin_state_up     = "true"
  security_group_ids = ["${openstack_compute_secgroup_v2.secgroup_1.id}"]

  fixed_ip {
    "subnet_id"  = "${openstack_networking_subnet_v2.subnet_1.id}"
    "ip_address" = "10.1.1.16"
  }
}


##----------------------------< Create a security group >----------------------------##
resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "Allow web traffic inbound"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
  rule {
    from_port   = 1
    to_port     = 65535
    ip_protocol = "tcp"
    cidr        = "10.1.1.0/24"
  }
}


##----------------------------< instance  haproxy create >----------------------------##
resource "openstack_compute_instance_v2" "haproxy" {
  name      = "haproxy"
  image_id  = "c09aceb5-edad-4392-bc78-197162847dd1"
  flavor_id = "c46be6d1-979d-4489-8ffe-e421a3c83fdd"

  key_pair        = "bryce"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  metadata {
    this = "haproxy"
  }

  network {
    port = "${openstack_networking_port_v2.port_1.id}"
    
  }
  user_data = "${file("haproxyconf.sh")}"
  
}

##----------------------------< webserver-1 create >----------------------------##
resource "openstack_compute_instance_v2" "webserver-1" {
  name      = "webserver-1"
  image_id  = "c09aceb5-edad-4392-bc78-197162847dd1"
  flavor_id = "c46be6d1-979d-4489-8ffe-e421a3c83fdd"

  #  key_pair        = "bryce"
  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  metadata {
    this = "that"
  }

  network {
    port = "${openstack_networking_port_v2.port_2.id}"
  }
  user_data = "${file("webserver.sh")}"
}

##----------------------------< webserver-2 create >----------------------------##
resource "openstack_compute_instance_v2" "webserver-2" {
  name      = "webserver-2"
  image_id  = "c09aceb5-edad-4392-bc78-197162847dd1"
  flavor_id = "c46be6d1-979d-4489-8ffe-e421a3c83fdd"

  #  key_pair        = "bryce"
  metadata {
    this = "that"
  }

  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_3.id}"
  }
  user_data = "${file("webserver.sh")}"
}

##----------------------------< webserver-3 create >----------------------------##
resource "openstack_compute_instance_v2" "webserver-3" {
  name      = "webserver-3"
  image_id  = "c09aceb5-edad-4392-bc78-197162847dd1"
  flavor_id = "c46be6d1-979d-4489-8ffe-e421a3c83fdd"

  #  key_pair        = "bryce"
  metadata {
    this = "that"
  }

  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_4.id}"
  }
  user_data = "${file("webserver.sh")}"
}

##----------------------------< webserver-4 create >----------------------------##
resource "openstack_compute_instance_v2" "webserver-4" {
  name      = "webserver-4"
  image_id  = "c09aceb5-edad-4392-bc78-197162847dd1"
  flavor_id = "c46be6d1-979d-4489-8ffe-e421a3c83fdd"

  #  key_pair        = "bryce"
  metadata {
    this = "that"
  }

  security_groups = ["${openstack_compute_secgroup_v2.secgroup_1.name}"]

  network {
    port = "${openstack_networking_port_v2.port_5.id}"
  }
  user_data = "${file("webserver.sh")}"
}


##----------------------------< floating ip create -1 >----------------------------##
resource "openstack_networking_floatingip_v2" "floatip_1" {
  pool = "internet"
}

resource "openstack_compute_floatingip_associate_v2" "floatip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.floatip_1.address}"
  instance_id = "${openstack_compute_instance_v2.haproxy.id}"
}
