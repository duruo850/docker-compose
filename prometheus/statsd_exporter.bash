#!/bin/bash

if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


run_without_volume() { # 没有volume的启动方式
	echo "run without volume"

	docker run -d -p 9102:9102 -p 9125:9125 -p 9125:9125/udp prom/statsd-exporter
}


run_with_volume() { # volume的启动方式
	echo "run with volume"

    # statsd_mapping.yml 还没找到
    # example https://gist.github.com/tam7t/64291f4ebbc1c45a1fc876b6c0613221

	docker run -d -p 9102:9102 -p 9125:9125 -p 9125:9125/udp \
        -v $PWD/statsd_mapping.yml:/tmp/statsd_mapping.yml \
        prom/statsd-exporter --statsd.mapping-config=/tmp/statsd_mapping.yml

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