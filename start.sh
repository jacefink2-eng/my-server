#!/bin/bash

# Start background health server for Render so deployments pass
python3 -m http.server 8080 &

echo "Initializing Zero-Download Network Fabric..."

# Your permanent Google Drive File ID extracted from your token link
FILE_ID="1o71ib5b1UL1fBiNJf7QgzeyZ60PVfpuY"

# Universal, non-expiring API download route for Google Drive
RAW_URL="https://google.com{FILE_ID}"

echo "Launching VM framework. Streaming disk blocks directly into QEMU..."

# Boot QEMU using the native HTTP protocol driver instead of a local file
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
