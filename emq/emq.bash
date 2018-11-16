#!/bin/bash
# 源码和使用参考https://github.com/dorinelfilip/emqx-docker/blob/master/start.sh，作者是同一个


if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


docker_run_simple() { # 简单的启动，只带dashboard
    docker run -d --name emq    \
        -p 1883:1883  -p 8080:8080 -p 8083-8084:8083-8084 -p 8883:8883 -p 18083:18083  -p 4369:4369 -p 6000-6100:6000-6100 \
        -e EMQ_LOADED_PLUGINS="emq_dashboard"   \
        duruo850/emq:2.3.11

}


docker_run_auth() { # 授权检查，带dashboard + 登录auth + acl访问auth
    # 开启后台管理系统 + http授权
    docker run -d --name emq    \
        -p 1883:1883  -p 8080:8080 -p 8083-8084:8083-8084 -p 8883:8883 -p 18083:18083  -p 4369:4369 -p 6000-6100:6000-6100 \
       -e EMQ_LOADED_PLUGINS="emq_dashboard,emq_auth_http"   \
       -e EMQ_AUTH__HTTP__AUTH_REQ="http://192.168.1.178:12000/mqtt/auth"  \
       -e EMQ_AUTH__HTTP__ACL_REQ="http://192.168.1.178:12000/mqtt/acl"  \
       duruo850/emq:2.3.11
}

docker_compose() { # docker compose启动
    docker-compose up -f docker-compose.yml -d
}


rm_containers() { # 删除容器
	echo "rm_containers"

	docker ps | grep duruo850/emq | awk '{print $1}' | xargs docker stop

	docker container prune -f
}



case $cmd in
docker_run_simple)
    docker_run_simple
;;
docker_run_auth)
    docker_run_auth
;;
docker_compose)
    docker_compose
;;
rm)
    rm_containers
;;
esac
exit 0
