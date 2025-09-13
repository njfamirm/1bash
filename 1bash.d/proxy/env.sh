#!/bin/bash

setProxy() {
  echo "🌐 Set http proxy on '1081', \`unsetProxy\` for disable"
  export http_proxy=http://127.0.0.1:1081
  export https_proxy=http://127.0.0.1:1081
  export all_proxy=http://127.0.0.1:1081
  export socks_proxy=socks5://127.0.0.1:1082
  git config --global http.proxy http://127.0.0.1:1081
  git config --global https.proxy http://127.0.0.1:1081
}

unsetProxy() {
  echo "🌐 Unset proxy"
  unset http_proxy
  unset https_proxy
  unset all_proxy
  git config --global --unset http.proxy
  git config --global --unset https.proxy
}
