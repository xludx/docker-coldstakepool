#!/bin/sh
set -e

echo "START: $1"
if [[ "$1" = 'init' ]]; then

    echo ============================================================
    echo "HOME: ${HOME}"
    echo "NAME: ${NAME}"
    echo "EMAIL: ${EMAIL}"
    echo "COMMENT: ${COMMENT}"
    echo "PASSPHRASE: ${PASSPHRASE}"
    echo "NETWORK: ${NETWORK}"
    echo ============================================================

    sed -i "s|HOME|${HOME}|g" ~/.gnupg/gpg.txt
    sed -i "s|NAME|${NAME}|g" ~/.gnupg/gpg.txt
    sed -i "s|EMAIL|${EMAIL}|g" ~/.gnupg/gpg.txt
    sed -i "s|COMMENT|${COMMENT}|g" ~/.gnupg/gpg.txt
    sed -i "s|PASSPHRASE|${PASSPHRASE}|g" ~/.gnupg/gpg.txt

    # cat ~/.gnupg/gpg.txt
    gpg --gen-key --batch ~/.gnupg/gpg.txt

    if [[ -f ~/coldstakepool/data/${NETWORK}/particl.conf ]]; then
        cp ~/coldstakepool/data/${NETWORK}/particl.conf ~/coldstakepool/data/${NETWORK}/particl.conf.bak
        rm -rf ~/coldstakepool/data/${NETWORK}/particl.conf
    fi
    if [[ -f ~/coldstakepool/data/${NETWORK}/stakepool/stakepool.json ]]; then
        cp ~/coldstakepool/data/${NETWORK}/stakepool/stakepool.json ~/coldstakepool/data/${NETWORK}/stakepool/stakepool.json.bak
        rm -rf ~/coldstakepool/data/${NETWORK}/stakepool/stakepool.json
    fi
    coldstakepool-prepare -datadir=~/coldstakepool/data/${NETWORK} -${NETWORK}
    # output=$(coldstakepool-prepare -datadir=~/coldstakepool/data/${NETWORK} -${NETWORK} | tee /dev/tty)
    echo
    echo
    echo ============================================================
    echo " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo ============================================================
    echo
    echo
    echo " - make sure you adjust the startheight parameter in data/${NETWORK}/stakepool.json"
    echo " - save both of the wallet recovery phrases, you can find them in this log"
    echo
fi

# init
if [[ "$1" = 'frontend' ]]; then
    if [[ ${NETWORK} = 'mainnet' ]]; then
        echo "environment.prod.ts:"
        cat src/environments/environment.prod.ts
    fi
    if [[ ${NETWORK} = 'testnet' ]]; then
        echo ============================================================
        echo "POOL: ${POOL}"
        echo "NETWORK: ${NETWORK}"
        echo "NVM: ${NVM}"
        echo "NVM_DIR: ${NVM_DIR}"
        echo ============================================================
        sed -i "s|url: ''|url: ${POOL}|g" src/environments/environment.ts
        echo "environment.ts:"
        cat src/environments/environment.ts
    fi
    node -v
    yarn -v
    npm -v
    yarn install
    yarn serve
fi



# start
#if [ "$1" = 'start' ]; then
#    if [ ! -f /app/laravel-echo-server.json ]; then
#        cp /etc/laravel-echo-server.json /app/laravel-echo-server.json
#        # Replace with environment variables
#        sed -i "s|LARAVEL_ECHO_SERVER_DB|${LARAVEL_ECHO_SERVER_DB:-redis}|i" /app/laravel-echo-server.json
#        sed -i "s|REDIS_HOST|${REDIS_HOST:-redis}|i" /app/laravel-echo-server.json
#        sed -i "s|REDIS_PORT|${REDIS_PORT:-6379}|i" /app/laravel-echo-server.json
#        sed -i "s|REDIS_PASSWORD|${REDIS_PASSWORD:-password}|i" /app/laravel-echo-server.json
#    fi
#    set -- laravel-echo-server "$@"
#fi

# first arg is `-f` or `--some-option`
#if [ "${1#-}" != "$1" ]; then
#	set -- laravel-echo-server "$@"
#fi

# exec "$@"
