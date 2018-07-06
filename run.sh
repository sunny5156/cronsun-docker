#!/bin/bash
/usr/sbin/sshd -D
echo 'supervisord -c /worker/supervisor/supervisord.conf'
supervisord -c /worker/supervisor/supervisord.conf