FROM ubuntu:22.04

# Ensure tmate is explicitly requested in the package list
RUN apt-get update && apt-get install -y qemu-system-x86 python3 curl tmate

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080
CMD ["/app/start.sh"]
