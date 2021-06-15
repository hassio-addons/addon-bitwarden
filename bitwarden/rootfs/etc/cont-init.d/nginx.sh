#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Bitwarden
# This file configures nginx
# ==============================================================================
declare certfile
declare keyfile

bashio::config.require.ssl

if bashio::config.true 'ssl'; then
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct-ssl.conf
    sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct-ssl.conf
    sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct-ssl.conf
fi
