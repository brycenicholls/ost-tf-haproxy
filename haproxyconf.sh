#!/bin/bash
sudo su -
yum install -y epel-release
yum -y install ansible
yum -y install haproxy
systemctl start haproxy



cat << EOF > /etc/haproxy/haproxy.cfg
frontend haproxy_in
        bind *:80
        default_backend haproxy_http
backend haproxy_http
        balance roundrobin
        mode http
        server webserver-1 10.1.1.12:80 check
        server webserver-2 10.1.1.13:80 check
        server webserver-3 10.1.1.14:80 check
        server webserver-4 10.1.1.15:80 check
EOF

systemctl reload haproxy
