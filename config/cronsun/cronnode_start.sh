#!/bin/bash
BASE_DIR=/worker/cronsun

${BASE_DIR}/cronnode -conf /${BASE_DIR}/conf/base.json >> /worker/data/cronsun/log/cronnode.log 2>&1