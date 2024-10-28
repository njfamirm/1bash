#!/bin/bash

setProxy() {
  echo "🌐 Set proxy on '1081', \`unsetProxy\` for disable"
  export http_proxy=http://localhost:1081
}

unsetProxy() {
  echo "🌐 Unset proxy"
  unset http_proxy
}
