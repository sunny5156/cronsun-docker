FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 

#RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.7/main" > /etc/apk/repositories

ARG TZ="Asia/Shanghai"

ENV TZ ${TZ}

ENV WORKER /worker
ENV SRC_DIR ${WORKER}/src

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

RUN mkdir -p  /data/db ${WORKER}/data/supervisor  ${WORKER}/src

ADD config ${WORKER}/

ADD lib/lrzsz-0.12.20.tar.gz ${SRC_DIR}/

# -----------------------------------------------------------------------------
# Install lrzsz
# ----------------------------------------------------------------------------- 
ENV lrzsz_version 0.12.20
RUN cd ${SRC_DIR} \
    #&& wget -q -O lrzsz-${lrzsz_version}.tar.gz  http://down1.chinaunix.net/distfiles/lrzsz-${lrzsz_version}.tar.gz \
    && tar -zxvf lrzsz-${lrzsz_version}.tar.gz  \
    && cd lrzsz-${lrzsz_version} \
    && ./configure \
    && make \
    && make install \
    && ln -s /usr/local/bin/lrz rz \
	&& ln -s /usr/local/bin/lsz sz
    

#RUN cd ${WORKER}/cronsun \
	#&& unzip cronsun.zip 
	#&& rm -rf cronsun.zip

#RUN cd ${WORKER}/etcd \
	#&& unzip etcd.zip 
	#&& cp etcd etcdctl /usr/bin/ \
	#&& rm -rf etcd.zip


#ADD shell /data/shell/

RUN chmod 777 -R /cronsun-etcd
	#&& chmod 777 /usr/bin/etcd /usr/bin/etcdctl 
	

#ADD config/.bash_profile /home/super/
#ADD config/.bashrc /home/super/

ADD shell/.bash_profile /root/
ADD shell/.bashrc /root/
ADD run.sh /

RUN sed -i 's@bin/ash@bin/bash@g' /etc/passwd

ENTRYPOINT ["/run.sh"]

EXPOSE 80 22 7079 2379 2380
