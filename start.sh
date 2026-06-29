#!/bin/bash

# Start a background health server so Render marks the deployment successful
python3 -m http.server 8080 &

# Create the specific workspace directory expected by the engine
WORKDIR="/tmp/vm"
mkdir -p "$WORKDIR"
rm -f "$WORKDIR/ubuntu.qcow2"

# Create a virtual named pipe matching your exact filename
mkfifo "$WORKDIR/ubuntu.qcow2"

# Your specific Google Drive file ID token
FILE_ID="1o71ib5b1UL1fBiNJf7QgzeyZ60PVfpuY"

echo "Initializing on-the-fly streaming pipeline for ubuntu.qcow2..."

# Run curl in the background, feeding Google Drive blocks straight into the pipe
curl -L -b "$WORKDIR/cookies.txt" \
  "https://google.com(curl -s -L -c "$WORKDIR/cookies.txt" 'https://google.com | grep -o 'confirm=[^&]*' | cut -d= -f2)&id="$FILE_ID" \
  -o "$WORKDIR/ubuntu.qcow2" &

echo "Launching VM emulator container. Listening to streaming blocks..."

# Boot QEMU using the stream pipe as a raw data input stream
qemu-system-x86_64 \
  -m 256 \
  -drive file="$WORKDIR/ubuntu.qcow2",format=raw,cache=none \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::22-:22 \
  -nographic
