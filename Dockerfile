FROM node:17-bullseye-slim

ARG UID=1000
ARG GID=1000
ARG username=citadel
RUN apt-get update && apt-get install -y curl vim procps nginx git sudo

ADD https://api.github.com/repos/urbit/urbit-bitcoin-rpc/git/refs/heads/master version.json
RUN git clone -b master https://github.com/urbit/urbit-bitcoin-rpc.git urbit-bitcoin-rpc

RUN cp -r /urbit-bitcoin-rpc/. /
ADD /rpc/mainnet-start.sh /mainnet-start.sh
ADD /rpc/server.js /src/server.js
# temp copy of index to overwrite with env var IP
ADD /index/index.html /index.html
# main index files
RUN mkdir /index
ADD index /index
ADD nginx.conf /etc/nginx/conf.d/nginx.conf

RUN npm install express
RUN npm audit fix

USER $USERNAME

EXPOSE 55555
EXPOSE 9090

ENTRYPOINT ["/mainnet-start.sh"]
