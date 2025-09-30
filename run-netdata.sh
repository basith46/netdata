#!/usr/bin/env bash
docker run -d --name=netdata_demo1 \
  -p 19997:19999 \
  --cap-add SYS_PTRACE --cap-add SYS_ADMIN \
  -v /etc/netdata:/etc/netdata \
  -v /var/lib/netdata:/var/lib/netdata \
  -v /var/log/netdata:/var/log/netdata \
  -v /etc/passwd:/host/etc/passwd:ro \
  -v /etc/group:/host/etc/group:ro \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /etc/os-release:/host/etc/os-release:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --restart unless-stopped \
  netdata/netdata:latest
