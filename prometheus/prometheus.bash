#!/bin/bash

if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


run_without_volume() { # 没有volume的启动方式
	echo "run without volume"

	docker run --name prometheus -d -p 127.0.0.1:9090:9090 prom/prometheus
}


run_with_volume() { # volume的启动方式
	echo "run with volume"

	docker create --name=prometheuscopy prom/prometheus

	rm -rf /srv/prometheus /srv/prometheus

	mkdir -p /srv/prometheus/config /srv/prometheus/data

	docker cp prometheuscopy:/etc/prometheus/prometheus.yml /etc/prometheus/prometheus.yml

	docker rm prometheuscopy

	docker run -d -p 9090:9090 -v /etc/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
       prom/prometheus
}


rm_containers() { # 删除容器
	echo "rm_containers"

	docker ps | grep prometheus | awk '{print $1}' | xargs docker stop

	docker container prune -f

	rm -rf /srv/prometheus /srv/prometheus
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