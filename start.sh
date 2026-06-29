#!/bin/bash

# Start the background health server you currently see on your webpage
python3 -m http.server 8080 &

# Create workspace and clear conflicting items
WORKDIR="/tmp/vm"
mkdir -p "$WORKDIR"
rm -f "$WORKDIR/ubuntu.qcow2"

# Create a virtual named pipe matching your exact filename
mkfifo "$WORKDIR/ubuntu.qcow2"

echo "Streaming ubuntu.qcow2 on-the-fly..."

# Your specific Google Drive file ID token link
TOKEN_LINK="https://google.com"

# Stream the raw network data directly into the virtual pipe
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$TOKEN_LINK" -o "$WORKDIR/ubuntu.qcow2" &

echo "Launching VM container. Reading streamed data blocks..."

# Boot QEMU using the stream pipe as a raw data input stream
# NOTE: We bind SSH (Port 22) inside the VM to Port 2222 on the container host
qemu-system-x86_64 \
  -m 256 \
  -drive file="$WORKDIR/ubuntu.qcow2",format=raw,cache=none \
  -net nic,model=virtio \
  -net user,hostfwd=tcp::2222-:22 \
  -nographic &

echo "Initializing remote terminal tunnel... please wait..."
sleep 5

# Launch tmate to tunnel the container's shell environment 
tmate -F &

# Wait for the session to connect, then force-print the terminal connection string to the logs
sleep 5
tmate display -p 'YOUR TERMINAL CONNECTION COMMAND: #{tmate_ssh}'
