FROM ubuntu:22.04

# Install QEMU, python, tmate, and socat for the proxy tunnel
RUN apt-get update && apt-get install -y qemu-system-x86 python3 curl tmate socat

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080
CMD ["/app/start.sh"]

