#!/bin/bash

docker run -d  -p 5000:5000 --restart=always --name registry -v /srv/registry/data:/var/lib/registry registry:2

# 搭建的http服务不是docker的授信服务，docker仅支持https，所以需要修改docker配置文件
# 在”/etc/docker/“目录下，创建”daemon.json“文件。在文件中写入：{ "insecure-registries":["192.168.1.xxx:5000"] }	