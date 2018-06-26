# 分布式计划任务cronsun
cronsun 是一个分布式任务系统，单个节点和 Linux 机器上的 crontab 近似。是为了解决多台 Linux  机器上 crontab 任务管理不方便的问题，同时提供任务高可用的支持（当某个节点死机的时候可以自动调度到正常的节点执行）。支持界面管理机器上的任务，支持任务失败邮件提醒，安装简单，使用方便，是替换 crontab 一个不错的选择。

[相关介绍](https://zhangge.net/5129.html)

## web管理

本文主要介绍功能，这里就简单写下关键步骤：

1、安装 MongoDB，强烈建议使用集群模式

2、安装 Etcd3，强烈建议使用集群模式

3、部署 cronsun

①、下载 cronsun：https://github.com/shunfei/cronsun/releases  (选择最新版本即可)

②、解压后修改 conf 目录下的配置文件：db.json 和 etcd.json，分别修改 MongoDB 和 etcd 的实际地址。

③、启动 web：./cronweb -conf conf/base.json (若要后台运行则使用 nohup)

④、启动 node：./cronnode -conf conf/base.json (若要后台运行则使用 nohup)

⑤、访问前台：http://x.x.x.x:7079/ui/

4、部署鉴权组件 aProxy，cronsun 在鉴权方面做的非常粗糙，所以这里用到了 cronsun 团队开发的 aProxy 鉴权组件，实现的原理为基于 Go 语言，反向代理了后端 WEB，从而实现域名和页面地址的访问控制，介绍地址：https://www.cnblogs.com/QLeelulu/p/aproxy.html


## job节点

cronsun 基于 etcd 实现了自动发现和注册的功能，所以添加节点非常简单，直接将 cronnode 和 conf 拷贝到客户端服务器启动之后，就能在前台->节点页面看到该服务器了，当然节点和 Etcd 以及 MongoDB 之间的网络必须畅通。

## 添加节点

```bash
curl http://172.17.0.5:2379/v2/members -XPOST -H "Content-Type: application/json" -d '{"peerURLs":["http://172.17.0.6:2380"]}'

```


## 运行
```bash
docker run --name="cronsun-docker" --hostname="cronsun" \
-p2204:22 \
-p7079:7079 \
daocloud.io/sunny5156/cronsun-docker:latest

```






