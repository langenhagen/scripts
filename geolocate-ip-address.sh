#!/bin/bash
#
# Given an IP-Address, looks up the according continent, country and city mapping
# using mmdblookup and a GeoIP2 database.
#
# REQUIREMENTS:
#
# This makes use of the tool mmdblookup that comes with libmaxminddb:
#   - https://maxmind.github.io/libmaxminddb/mmdblookup.html
#   - https://github.com/maxmind/libmaxminddb
#
# Install mmdblookup first. To download mmdblookup e.g. for Ubuntu, do:
#   sudo add-apt-repository -y ppa:maxmind/ppa
#   sudo apt update
#   sudo apt install -y libmaxminddb0 libmaxminddb-dev mmdb-bin
#
# You also need the GeoIP City Database, e.g. "GeoLite2-City.mmdb":
#   https://github.com/leev/ngx_http_geoip2_module
#
#   - e.g. via:
#       wget https://geolite.maxmind.com/download/geoip/database/GeoLite2-City.tar.gz
#       tar xfz GeoLite2-City.tar.gz
#
#
# NOTE:
#   - the GeoIP database can become outdated and thus may be updated before usage.
#
# The whole thing was made possible by maxmind: https://www.maxmind.com/en/home
#
# author: andreasl

geoip_database_city="${HOME}/Dev/Zeugs/GeoLite2-City.mmdb"
ip_address="${1}"

continent=$(mmdblookup -v -f "${geoip_database_city}" -i ${ip_address} continent names en | \
    grep -oP '"\K[^"\047]+(?=["\047])')
country=$(mmdblookup -v -f "${geoip_database_city}" -i ${ip_address} country names en | \
    grep -oP '"\K[^"\047]+(?=["\047])')
city=$(mmdblookup -v -f "${geoip_database_city}" -i ${ip_address} city names en | \
    grep -oP '"\K[^"\047]+(?=["\047])')
postal_code=$(mmdblookup -v -f "${geoip_database_city}" -i ${ip_address} postal code | \
    grep -oP '"\K[^"\047]+(?=["\047])')

printf "${continent}
${country}
${city}
${postal_code}\n"
