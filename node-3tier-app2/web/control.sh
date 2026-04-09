#!/bin/bash

TASK=$1
WORK_DIR=/app

case $TASK in
    "deploy")
        cd /home/admin/toptal-project/node-3tier-app2/web && \
        git pull origin main && \
        /usr/bin/docker-compose stop && \
        /usr/bin/docker image rm -f web-web && \
        /usr/bin/docker-compose up -d ;;
    
    "stop")
        cd /home/admin/toptal-project/node-3tier-app2/web && \
        /usr/bin/docker-compose stop ;;

    "restart")
        cd /home/admin/toptal-project/node-3tier-app2/web && \
        /usr/bin/docker-compose restart ;;
esac


