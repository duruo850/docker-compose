#!/bin/bash

docker run -d --name emqtt \
    -p 1883:1883  -p 8080:8080 -p 8083-8084:8083-8084 -p 8883:8883 -p 18083:18083  -p 4369:4369 -p 6000-6100:6000-6100 \
    -e EMQ_NAME="emq" \
    -e EMQ_HOST="emq.qiteck.net" \
    -e EMQ_LOADED_PLUGINS="emq_auth_http,emq_auth_username" \
    -e EMQ_AUTH__HTTP__AUTH-REQ="http://127.0.0.1:8991/mqtt/auth" \
    -v `pwd`/emq.conf:/opt/emqttd/etc/emq.conf \
    duruo850/emq:2.3.11
