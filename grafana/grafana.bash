#!/bin/bash

if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


run_without_volume() { # 没有volume的启动方式
	echo "run without volume"

	docker run -d --name=grafana -p 3000:3000 grafana/grafana
}


run_with_volume() { # volume的启动方式
	echo "run with volume"
	run_without_volume
}


rm_containers() { # 删除容器
	echo "rm_containers"

	docker ps | grep grafana | awk '{print $1}' | xargs docker stop

	docker container prune -f
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