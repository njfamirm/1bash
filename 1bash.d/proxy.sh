#!/bin/bash

setProxy() {
  unset CACHED_COUNTRY
  echo "🌐 Set proxy on '1081', \`unsetProxy\` for disable"
  export http_proxy=http://localhost:1081
}

unsetProxy() {
  unset CACHED_COUNTRY
  echo "🌐 Unset proxy"
  unset http_proxy
}

function proxy() {
  if [ -f /tmp/v2ray_pid ]; then
    echo "🛑 Previously started!"
    return
  fi

  local path="$HOME/v2ray-config.json"
  echo "🚀 Run $path v2ray config"
  v2ray run --config $path > /dev/null &
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
