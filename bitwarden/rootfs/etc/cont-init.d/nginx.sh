#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Bitwarden
# This file configures nginx
# ==============================================================================
declare certfile
declare hassio_dns
declare keyfile
declare max_body_size

bashio::config.require.ssl

if bashio::config.true 'ssl'; then
    certfile=$(bashio::config 'certfile')
    keyfile=$(bashio::config 'keyfile')

    mv /etc/nginx/servers/direct-ssl.disabled /etc/nginx/servers/direct.conf
    sed -i "s#%%certfile%%#${certfile}#g" /etc/nginx/servers/direct.conf
    sed -i "s#%%keyfile%%#${keyfile}#g" /etc/nginx/servers/direct.conf
else
    mv /etc/nginx/servers/direct.disabled /etc/nginx/servers/direct.conf
fi

hassio_dns=$(bashio::dns.host)
sed -i "s/%%hassio_dns%%/${hassio_dns}/g" /etc/nginx/includes/resolver.conf

