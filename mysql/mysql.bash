#!/bin/bash

if [ $# -lt 1 ] ; then
    cmd=run_with_volume
else
    cmd=$1
fi


run_without_volume() { # 没有volume的启动方式
	
	docker run  --name=mysql -d -p 3306:3306  --restart always  -e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_ROOT_HOST=% mysql/mysql-server:5.7.24
}


run_with_volume() { # volume的启动方式
	
	docker create --name=mysqlcopy mysql/mysql-server:5.7.24
		
	rm -rf /srv/mysql /srv/mysql

	mkdir -p /srv/mysql/config /srv/mysql/data

	docker cp mysqlcopy:/etc/my.cnf /srv/mysql/config/

	docker rm mysqlcopy
	
	# MYSQL ROOT HOST的设置需要在/var/lib/mysql没有创建之前
	docker run --name=mysql -d -p 3306:3306  --restart always  \
		-e MYSQL_ROOT_PASSWORD=123456 -e MYSQL_ROOT_HOST=% \
		-v /srv/mysql/config/my.cnf:/etc/my.cnf -v /srv/mysql/data:/var/lib/mysql \
		mysql/mysql-server:5.7.24 
}


rm() { # 删除容器

	docker stop mysql
	docker rm mysql
}
		
		
		
case $cmd in
run_with_volume)
    run_with_volume
;;
run_without_volume)
    run_without_volume
;;
rm)
    rm
;;
esac
exit 0
