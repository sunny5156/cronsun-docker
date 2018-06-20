FROM alpine:3.6
# FROM alpine:3.7

MAINTAINER sunny5156 <sunny5156@qq.com> 
RUN apk add --update openssh
RUN echo "root:123456" | chpasswd
RUN ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N '' 
RUN ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N '' 
EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]