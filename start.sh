#!/bin/bash

# Start background health server for Render so deployments pass
python3 -m http.server 8080 &

echo "Initializing Zero-Download Network Fabric..."
echo "Launching VM framework. Streaming disk blocks directly into QEMU..."

# REPLACE THIS PLACEHOLDER with your raw Discord or Catbox direct link
RAW_URL="https://discordapp.com"

# Boot QEMU using native HTTP block protocol mappings
# This downloads 0 bytes to Render's disk and runs entirely over the wire!
qemu-system-x86_64 \
  -m 256 \
  -drive file.driver=http,file.url="$RAW_URL",format=qcow2,cache=writeback,read-only=on \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::2222-:22 \
  -nographic &

echo "Initializing remote terminal tunnel... please wait..."
sleep 5

# Start connection management engine
tmate -F &

sleep 5
tmate display -p 'YOUR TERMINAL CONNECTION COMMAND: #{tmate_ssh}'

