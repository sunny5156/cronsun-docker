FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 



#RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.7/main" > /etc/apk/repositories

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add curl bash tzdata openssh\
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    #&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N '' \
    #&& ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
    && echo "root:root" | chpasswd \
    && rm -rf /var/cache/apk/*
    
RUN apk add --no-cache git make musl-dev go mongodb 


RUN mkdir -p /data/cronsun /data/etcd /data/db

ADD cronsun/cronsun.zip /data/cronsun/ 
ADD etcd/etcd.zip /data/etcd/

RUN cd /data/cronsun \
	&& unzip cronsun.zip 
	#&& rm -rf cronsun.zip

RUN cd /data/etcd \
	&& unzip etcd.zip \
	&& cp etcd etcdctl /usr/bin/ 
	#&& rm -rf etcd.zip

#RUN alias ll='ls -lsh'
  
RUN echo "/usr/sbin/sshd -D" >>/etc/start.sh

ADD shell /data/

EXPOSE 80 22 7079 

CMD ["/bin/sh","/etc/start.sh"]