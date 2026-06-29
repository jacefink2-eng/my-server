#!/bin/bash

# Start background health server for Render
python3 -m http.server 8080 &

# Build local directory path
WORKDIR="/tmp/vm"
mkdir -p "$WORKDIR"
rm -f "$WORKDIR/ubuntu.qcow2"

# Create a virtual named pipe
mkfifo "$WORKDIR/ubuntu.qcow2"

# REPLACE THIS LINK with your new direct download link from Step 1
DIRECT_LINK="https://your-new-direct-link-here.com"

echo "Streaming ubuntu.qcow2 on-the-fly from high-speed storage..."

# Stream the raw file directly into the named pipe backend
curl -L "$DIRECT_LINK" -o "$WORKDIR/ubuntu.qcow2" &

echo "Launching VM engine. Booting stream blocks..."

# Run the virtual machine directly from the incoming network stream
qemu-system-x86_64 \
  -m 256 \
  -drive file="$WORKDIR/ubuntu.qcow2",format=raw,cache=none \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::22-:22 \
  -nographic
