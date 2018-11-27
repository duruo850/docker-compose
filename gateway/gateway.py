#!/usr/bin/python3
# coding=utf-8
"""
Created on 2018-11-27
@author: Jay
"""
import argparse
import subprocess


def do_cmd(cmd):
    """
    执行命令
    :param cmd:
    :return:
    """
    print("do_cmd start cmd:=========%s========" % cmd)
    stdout, stderr = subprocess.Popen(
        cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True, close_fds=True,
        executable='/bin/bash').communicate()
    print("do_cmd end cmd:%s, stdout:%s stderr:%s" % (cmd, stdout, stderr))


class IService:
    def __init__(self, args):
        """

        :param args: 启动参数
        """
        self.args = args

    def start(self):
        """
        开始服务
        docker run -d -p 80:80 -p 443:443 \
        -e CONSUL_URL="192.168.1.136:8500" \
        -e DOMAIN=my.domain \
        -e EMAIL=my.email@my.domain \
        -v `pwd`/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf \
        -v `pwd`/lua/auth/auth.lua:/usr/local/openresty/lualib/auth/auth.lua \
        duruo850/gateway:1.0.0
        :return:
        """
        print("start")
        cmd = """ docker run --name={name} -d -p 80:80 -p 443:443 """.format(name=self.args.name)
        cmd += """ -e CONSUL_URL="{consul_url}" """.format(consul_url=self.args.consul_url)
        cmd += """ -e DOMAIN={domain} """.format(domain=self.args.domain) if self.args.domain else ""
        cmd += """ -e EMAIL={email} """.format(email=self.args.email) if self.args.email else ""
        cmd += """ -v `pwd`/nginx.conf:/usr/local/openresty/nginx/conf/nginx.conf """ if self.args.volume == "enable" else ""
        cmd += """ -v `pwd`/lua/auth/auth.lua:/usr/local/openresty/lualib/auth/auth.lua""" if self.args.volume == "enable" else ""
        cmd += """ duruo850/gateway:1.0.0 """
        do_cmd(cmd)

    def stop(self):
        """
        结束服务
        :return:
        """
        print("stop")
        cmd = """docker ps | grep {name} """.format(name=self.args.name)
        cmd += """| awk '{print $1}' | xargs docker stop"""
        do_cmd(cmd)

    def clear(self):
        """
        清空服务
        :return:
        """
        print("run_without_volume")
        self.stop()
        do_cmd("""docker container prune -f""")


if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument('command', type=str, help="support this command: start/stop/clear")
    p.add_argument('--consul_url', type=str, default="192.168.1.136:8500", help="consul host url", required=False)
    p.add_argument('--name', type=str, default="gateway", help="service name", required=False)
    p.add_argument('--volume', type=str, default="disable",
                   help="whether to enable the volume, enable/disable", required=False)
    p.add_argument('--domain', type=str, default="",  help="domain for certs generator", required=False)
    p.add_argument('--email', type=str, default="", help="email for certs generator", required=False)

    pargs = p.parse_args()
    print("pargs,", pargs)

    obj = IService(pargs)
    if hasattr(obj, pargs.command):
        getattr(obj, pargs.command)()
    else:
        print(p.format_usage())
        exit(1)
