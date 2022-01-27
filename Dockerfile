# NodeJS Builder container
FROM buildpack-deps:bullseye-curl as nodejs-builder

RUN apt-get update && \
  apt-get install -y xz-utils python && \
  rm -rf /var/lib/apt/lists/*

RUN curl https://nodejs.org/dist/v14.18.1/node-v14.18.1-linux-arm64.tar.xz --output node-v14.18.1-linux-arm64.tar.xz
RUN tar xvf node-v14.18.1-linux-arm64.tar.xz

# urbit-bitcoin-rpc Builder container
FROM buildpack-deps:bullseye as urbit-rpc-builder

ADD https://api.github.com/repos/urbit/urbit-bitcoin-rpc/git/refs/heads/master version.json
RUN git clone -b master https://github.com/urbit/urbit-bitcoin-rpc.git urbit-bitcoin-rpc

# urbit-bitcoin-node container
FROM debian:bullseye-slim

# These buildargs can be set during container build time with --build-arg UID=[uid]
ARG UID=1000
ARG GID=1000
ARG USERNAME=user

RUN apt-get update && \
  apt-get install -y iproute2 sudo && \
  rm -rf /var/lib/apt/lists/*

# Allow the new user write access to /etc/hosts
RUN groupadd -g $GID -o $USERNAME && \
  useradd -m -u $UID -g $GID -o -d /home/$USERNAME -s /bin/bash $USERNAME && \
  echo "$USERNAME    ALL=(ALL:ALL) NOPASSWD: /usr/bin/append-to-hosts" | tee -a /etc/sudoers

# Copy files from the builder containers
COPY --from=nodejs-builder /node-v14.18.1-linux-arm64/ /usr/local/
COPY --from=urbit-rpc-builder /urbit-bitcoin-rpc/* /
COPY --from=urbit-rpc-builder /urbit-bitcoin-rpc/src /src

# Overwrite two files in the dist with our local slightly modified versions
ADD /rpc/mainnet-start.sh /mainnet-start.sh
ADD /rpc/server.js /src/server.js

RUN npm install express
RUN npm audit fix

USER $USERNAME

EXPOSE 50002

ENTRYPOINT ["/mainnet-start.sh"]




