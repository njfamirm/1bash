# connect to out server directly
alias ssh_tunnel_direct='ssh -C -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -c aes128-ctr -MND 0.0.0.0:1080 srvo'

# connect to middle server
alias ssh_tunnel_multi_hub='ssh -J mci -C -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -c aes128-ctr -MND 0.0.0.0:1080 srvo'
alias ssh_tunnel_multi_hub='ssh -c aes128-ctr -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -MNL 0.0.0.0:1080:127.0.0.1:1080 mci'

# Combined function for one-step proxy setup
function tunnel() {
  close_tunnel
  echo "🔄 Setting up tunnel and proxy..."
  proxy
  setProxy
  ssh_tunnel_multi_hub
}

# Direct tunnel to final server (skip middle server)
function direct_tunnel() {
  close_tunnel
  echo "🔄 Setting up direct tunnel..."
  proxy
  setProxy
  ssh_tunnel_direct
}

# Close everything in one command
function close_tunnel() {
  stop_proxy
  unsetProxy
  echo "🔄 Checking for SSH tunnel processes..."
  tunnel_pids=$(pgrep -f "ssh.*MN[DL].*1080")
  if [ -n "$tunnel_pids" ]; then
    echo "🛑 Killing SSH tunnel processes: $tunnel_pids"
    kill $tunnel_pids
  else
    echo "⚠️ No SSH tunnel processes found"
  fi
  echo "✅ All proxy services stopped"
}
