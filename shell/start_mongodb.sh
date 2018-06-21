#!/bin/bash
#运行mongodb
nohup mongod --bind_ip 0.0.0.0  >/dev/null 2>&1 &
