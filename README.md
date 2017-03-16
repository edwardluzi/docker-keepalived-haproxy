# docker-keepalived-haproxy
---
## Purpose
Keepalived and HAProxy are wildly used to setup a High-Availability TCP/HTTP Load Balancer in an active/passive configuration. HAProxy had provided an office docker image release in docker hub, and there are also a lot of keepalived docker images contribued by talant developers in docker hub, but it is not easy to find out a docker image that contained both HAProxy and keepalived.


## Configuration

### HAProxy
HAProxy is configured by a configuration file, haproxy.cfg, please map the folder that contains haproxy.cfg to docker container volume /usr/local/etc/haproxy, a simple sample haproxy.cfg is listed below:
```
global
    daemon
    maxconn 256

defaults
    mode http
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http-in
    bind *:80
    default_backend servers

backend servers
    server tomcat1 192.168.1.52:8888 maxconn 32
    server tomcat2 192.168.1.53:8888 maxconn 32
```

### keepalived
 Keepalived is configured by environment variables as below

- `INTERFACE`:           interface to set virtual IP
- `VIRTUAL_IP`:          vip
- `VIRTUAL_MASK`:        vip mask
- `STATE`:               master or backup
- `VIRTUAL_ROUTER_ID`:   must be the same in all nodes
- `PRIORITY`:            101 on master, 100 on backups


## Usage with Docker Compose

docker-compose.yaml
```
version: '3'
services:

    keepalived_haproxy1:
        image: goldenroute/keepalived-haproxy:latest
        volumes:
            - /haproxy:/usr/local/etc/haproxy:ro
            - /keepalived:/keepalived1
            - /var/run/docker.sock:/var/run/docker.sock
            - /root/.docker:/root/.docker
        environment:
            INTERFACE: "enp0s3"
            STATE: "MASTER"
            VIRTUAL_ROUTER_ID: "51"
            PRIORITY: "101"
            VIRTUAL_IP: "192.168.1.20"
            VIRTUAL_MASK: "24"
        command: [-f, /usr/local/etc/haproxy/haproxy.cfg]
        restart: always
        network_mode: host
        privileged: true
```