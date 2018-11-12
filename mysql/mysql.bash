docker run -d  -p 5000:5000 --restart=always --name registry -v /srv/registry/data:/var/lib/registry registry:2	

sudo docker create --name=mysqlcopy mysql/mysql-server:5.7.24 --character-set-server=utf8mb4  --collation-server=utf8mb4_col

sudo docker cp mysqlcopy:/etc/my.conf /srv/mysql/config/my.conf

sudo docker rm mysqlcopy

sudo docker run --name=mysql -d --restart always  -e MYSQL_ROOT_PASSWORD=123456 -v /srv/mysql/config/my.conf:/etc/my.cnf  -v /srv/mysql/data:/var/lib/mysql mysql/mysql-server:5.7.24
