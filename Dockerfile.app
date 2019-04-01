FROM ubuntu:16.04

ENV BUILD_PACKAGES git yarn wget bash make gcc g++ gnupg ca-certificates software-properties-common build-essential python3.6 python3.6-dev python3-pip python3.6-venv python3 nginx tmux python3-zmq lynx htop
ENV NPM_PACKAGES wait-port ts-node tslint typescript

ENV NAME test
ENV EMAIL test@particl.xyz
ENV COMMENT comment
ENV PASSPHRASE changeme
ENV NETWORK testnet
ENV NVM_DIR /root/.nvm

RUN apt-get update && \
        apt-get install -y software-properties-common curl apt-transport-https && \
        add-apt-repository ppa:jonathonf/python-3.6
#        curl -sL https://deb.nodesource.com/setup_11.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
        echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y && \
        apt-get install -y $BUILD_PACKAGES && \
        rm -rf /var/lib/apt/lists/*

RUN mkdir -p $NVM_DIR
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
        nvm install node && \
        npm install -g -s --no-progress $NPM_PACKAGES

# update pip
RUN python3.6 -m pip install pip --upgrade && \
        python3.6 -m pip install wheel
RUN pip3 install plyvel

RUN ln -sf /bin/bash /bin/sh

WORKDIR /root
RUN git clone https://github.com/tecnovert/particl-coldstakepool coldstakepool
WORKDIR /root/coldstakepool
# RUN git checkout dockerize
RUN mkdir -p /root/.gnupg
COPY ./bin/entrypoint.sh /root/coldstakepool/bin/entrypoint.sh
COPY gpg.txt /root/.gnupg/gpg.txt
RUN chmod +x bin/entrypoint.sh
RUN pip3 install .


