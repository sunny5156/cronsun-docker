FROM alpine:3.6
# FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 

RUN apk add --update openssh


RUN echo "/usr/sbin/sshd -D" >>/etc/start.sh


EXPOSE 80
EXPOSE 22

CMD ["/bin/sh","/etc/start.sh"]