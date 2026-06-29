#!/bin/bash

# Start background health server for Render
python3 -m http.server 8080 &

echo "Initializing Zero-Download Network Fabric..."

# 1. PASTE YOUR ACTUAL HTTPS LINK HERE (Leave the quotes!)
REAL_HTTPS_URL="YOUR_HTTPS_LINK_HERE"

# Extract the hostname (e.g., cdn.discordapp.com)
HOST=$(echo "$REAL_HTTPS_URL" | sed -e 's|^[^/]*//||' -e 's|/.*||')
# Extract the URI path (e.g., /attachments/.../ubuntu.qcow2)
URI=$(echo "$REAL_HTTPS_URL" | sed -e 's|^[^/]*//||' -e 's|^[^/]*||')

echo "Starting secure background proxy tunnel for: $HOST"

# Start a background proxy that listens on local port 8000 and securely forwards to the HTTPS host
socat TCP-LISTEN:8000,fork,reuseaddr OPENSSL:$HOST:443,verify=0 &
sleep 2

# This builds an unencrypted local HTTP link that QEMU can read without crashing
LOCAL_HTTP_URL="http://127.0.0.1:8000$URI"

echo "Launching VM framework. Streaming disk blocks through local proxy..."

# Boot QEMU using the unencrypted proxy URL
qemu-system-x86_64 \
  -m 256 \
  -drive file.driver=http,file.url="$LOCAL_HTTP_URL",format=qcow2,cache=writeback,read-only=on \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::2222-:22 \
  -nographic &

echo "Initializing remote terminal tunnel... please wait..."
sleep 5

# Start connection management engine
tmate -F &

sleep 5
tmate display -p 'YOUR TERMINAL CONNECTION COMMAND: #{tmate_ssh}'
