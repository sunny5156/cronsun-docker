#!/bin/bash
BASE_DIR=/worker/cronsun

${BASE_DIR}/cronweb -conf /${BASE_DIR}/conf/base.json >> /worker/data/cronsun/log/cronweb.log 2>&1