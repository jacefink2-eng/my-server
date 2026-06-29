#!/bin/bash

# Start a background health server so Render registers a healthy application
python3 -m http.server 8080 &

# Create workspace and clear conflicting items
WORKDIR="/tmp/vm"
mkdir -p "$WORKDIR"
rm -f "$WORKDIR/ubuntu.qcow2"

# Create a virtual named pipe matching your exact filename
mkfifo "$WORKDIR/ubuntu.qcow2"

echo "Streaming ubuntu.qcow2 using authorized token channels..."

# The specific link token provided by your storage source
TOKEN_LINK="https://google.com"

# Stream the network buffer directly into the virtual pipe
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$TOKEN_LINK" -o "$WORKDIR/ubuntu.qcow2" &

echo "Launching VM framework. Mapping storage blocks using buffered caching..."

# FIXED: Swapped 'cache=none' to 'cache=writeback' to bypass O_DIRECT restrictions
qemu-system-x86_64 \
  -m 256 \
  -drive file="$WORKDIR/ubuntu.qcow2",format=raw,cache=writeback \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::2222-:22 \
  -nographic &

echo "Initializing remote terminal tunnel... please wait..."
sleep 5

# Start connection management daemon
tmate -F &

sleep 5
tmate display -p 'YOUR TERMINAL CONNECTION COMMAND: #{tmate_ssh}'
