FROM ubuntu:22.04

# Install only the essentials to conserve container image overhead
RUN apt-get update && apt-get install -y qemu-system-x86 python3 curl

WORKDIR /app

COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

CMD ["/app/start.sh"]
