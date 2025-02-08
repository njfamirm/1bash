#!/bin/bash

setProxy() {
  echo "🌐 Set proxy on '1081', \`unsetProxy\` for disable"
  export http_proxy=http://127.0.0.1:1081
}

unsetProxy() {
  echo "🌐 Unset proxy"
  unset http_proxy
}

function proxy() {
  local config_file="$HOME/.v2ray/${1:-'config'}.json"

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
