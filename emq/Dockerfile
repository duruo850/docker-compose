FROM duruo850/emq:2.3.11

COPY ./emq.conf /opt/emqttd/etc/

# 管理后台是可以配置auth_http的，不过auth_req和acl_req都需要同时配置，如果只想配置auth_req，必须修改配置文件
COPY ./emq_auth_http.conf /opt/emqttd/etc/plugins/
