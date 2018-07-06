#!/bin/bash
mongod --bind_ip 0.0.0.0  >> /worker/data/mongodb/log/mongod.log 2>&1