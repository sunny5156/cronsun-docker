FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 

RUN apk add --no-cache openssh \
  && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && echo "root:123456" | chpasswd
  
RUN echo "/usr/sbin/sshd -D" >>/etc/start.sh


EXPOSE 80
EXPOSE 22

CMD ["/bin/sh","/etc/start.sh"]