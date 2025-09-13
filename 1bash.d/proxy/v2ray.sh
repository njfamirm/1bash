#!/bin/bash

function proxy() {
  local config_file="$ONE_BASH/1bash.d/proxy/ssh-tunnel-v2ray.json"

  if [ -f /tmp/v2ray_pid ]; then
    stop_proxy
  fi

  echo "🚀 Run $config_file v2ray config"
  v2ray run --config $config_file > /dev/null &
  echo $! > /tmp/v2ray_pid
}

function stop_proxy() {
  if [ -f /tmp/v2ray_pid ]; then
    kill $(cat /tmp/v2ray_pid)
    rm -rf /tmp/v2ray_pid
    echo "🛑 v2ray stopped"
  else
    echo "⚠️ No v2ray process found"
  fi
}
