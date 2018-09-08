# ost-tf-haproxy
Simple HAproxy setup using openstack and terraform

### Required
**You will need to source your openstack RC file for this to work.**

**you will need to amend the image and flavor ID to reflect your environment**

### Summary
The script will create
- A network
- ports for static IP addresses
- A security group 
- 5 centos instances
  - 1 for the haproxy server
  - 4 for the webservers
- **haproxyconf.sh** injects the config into the haproxy server
- **webserver.sh** injects config to print the hostname (for testing haproxy)
