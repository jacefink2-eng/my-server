FROM ubuntu:22.04

RUN apt-get update && apt-get install -y qemu-system-x86 python3 curl tmate

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

EXPOSE 8080

# This dummy variable breaks Render's hidden Docker layer cache completely
ENV FORCE_REBUILD_CACHE=v2

CMD ["/app/start.sh"]
