FROM debian:buster-slim
ARG UID=1000
ARG GID=1000
ARG username=umbrel
RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash 
RUN apt-get update && apt-get install -y vim procps nginx nodejs npm git sudo

ADD https://api.github.com/repos/urbit/urbit-bitcoin-rpc/git/refs/heads/master version.json
RUN git clone -b master https://github.com/urbit/urbit-bitcoin-rpc.git urbit-bitcoin-rpc

ADD /rpc/mainnet-start.sh /mainnet-start.sh
ADD /rpc/server.js /src/server.js
ADD nginx.conf /etc/nginx/conf.d/nginx.conf

RUN npm install express
RUN npm audit fix

USER $USERNAME

EXPOSE 50002
EXPOSE 9090

ENTRYPOINT ["/mainnet-start.sh"]
