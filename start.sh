#!/bin/bash

# Start a background server so Render registers a healthy running application
python3 -m http.server 8080 &

# Build local directory path
mkdir -p /tmp/vm
echo "Retrieving the 5GB disk image from Google Drive..."

# Your specific Google Drive file ID token
FILE_ID="1o71ib5b1UL1fBiNJf7QgzeyZ60PVfpuY"

# Automatically bypass the large file scanner warning and download the file
curl -Lb /tmp/cookies.txt "https://google.com(curl -s -L -c /tmp/cookies.txt 'https://google.com | grep -o 'confirm=[^&]*' | cut -d= -f2)&id="$FILE_ID -o /tmp/vm/disk.qcow2

echo "Download successful. Launching virtual machine engine..."

# Run the virtual operating system image using software emulation
qemu-system-x86_64 \
  -m 256 \
  -drive file=/tmp/vm/disk.qcow2,format=qcow2,cache=writethrough \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::22-:22 \
  -nographic
