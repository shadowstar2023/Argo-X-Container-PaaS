FROM node:latest
# 添加一个非 root 用户
RUN useradd -m -s /bin/bash myuser

# 切换到新用户
USER myuser
EXPOSE 3000
WORKDIR /app
COPY files/* /app/

RUN apt-get update &&\
    apt-get install -y iproute2 &&\
    npm install -r package.json &&\
    npm install -g pm2 &&\
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb &&\
    dpkg -i cloudflared.deb &&\
    rm -f cloudflared.deb &&\
    chmod +x web.js

ENTRYPOINT [ "node", "server.js" ]
