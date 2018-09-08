# ost-tf-haproxy
Simple HAproxy setup using openstack and terraform

### Note
**You will need to source your openstack RC file for this to work.**

**You will need to amend the image and flavor ID to reflect your environment**

### Summary
The script will create
- A network
- Ports for static IP addresses
- A security group 
- 5 centos instances
  - 1 for the haproxy server
  - 4 for the webservers
- **haproxyconf.sh** injects the config into the haproxy server
- **webserver.sh** injects config to print the hostname (for testing haproxy)
