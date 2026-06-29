FROM ubuntu:22.04

# Install dependencies needed for downloading and running the VM
RUN apt-get update && apt-get install -y qemu-system-x86 python3 curl

WORKDIR /app

# Copy the boot script from GitHub into the container
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Expose Render's default web service communication port
EXPOSE 8080

CMD ["/app/start.sh"]
