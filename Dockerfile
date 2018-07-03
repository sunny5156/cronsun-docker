FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 

#RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.7/main" > /etc/apk/repositories

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

RUN apk upgrade --update \
    && apk add curl bash tzdata openssh \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
    && ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' \
    && echo "root:root" | chpasswd \
    && rm -rf /var/cache/apk/*
    
RUN apk add --no-cache git make musl-dev go mongodb 

RUN apk add python supervisor

RUN mkdir -p /cronsun-etcd/cronsun /cronsun-etcd/etcd /data/db /cronsun-etcd/data/supervisor 

ADD config /cronsun-etcd/

#RUN cd /cronsun-etcd/cronsun \
	#&& unzip cronsun.zip 
	#&& rm -rf cronsun.zip

#RUN cd /cronsun-etcd/etcd \
	#&& unzip etcd.zip 
	#&& cp etcd etcdctl /usr/bin/ \
	#&& rm -rf etcd.zip

#RUN alias ll='ls -lsh'
  
RUN echo "/usr/sbin/sshd -D" >>/etc/start.sh

#ADD shell /data/shell/

RUN chmod 777 -R /cronsun-etcd
	#&& chmod 777 /usr/bin/etcd /usr/bin/etcdctl 
	

#ADD config/.bash_profile /home/super/
#ADD config/.bashrc /home/super/


EXPOSE 80 22 7079 2379 2380

CMD ["/bin/sh","/etc/start.sh"]