#!/bin/bash

if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


run_without_volume() { # 没有volume的启动方式
	echo "run without volume"

	docker run --name redis -d --restart=always -p 6379:6379 -e REDIS_PASSWORD='rdspwd11131456' duruo850/redis:5.0.1-alpine3.8
}


run_with_volume() { # volume的启动方式
	# 注意需要取消root对/srv/redis目录的使用
	echo "run with volume"
	
	docker create --name=rediscopy duruo850/redis:5.0.1-alpine3.8
		
	rm -rf /srv/redis /srv/redis

	mkdir -p /srv/redis/config /srv/redis/data

	docker cp rediscopy:/usr/local/bin/redis.conf /srv/redis/config/

	docker rm rediscopy

	docker run --name redis -d --restart=always -p 6379:6379 \
	    -e REDIS_PASSWORD='rdspwd11131456' \
        -v /srv/redis/config/redis.conf:/usr/local/bin/redis.conf \
        -v /srv/redis/data:/data \
        duruo850/redis:5.0.1-alpine3.8
}


rm_containers() { # 删除容器
	echo "rm_containers"

	docker ps | grep redis | awk '{print $1}' | xargs docker stop

	docker container prune -f

	rm -rf /srv/redis /srv/redis
}
		
		
		
case $cmd in
run_with_volume)
    run_with_volume
;;
run_without_volume)
    run_without_volume
;;
rm)
    rm_containers
;;
esac
exit 0
