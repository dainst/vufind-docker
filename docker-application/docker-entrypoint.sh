#!/bin/bash

cd /usr/local/vufind

cp /usr/local/vufind-configs/config.ini /usr/local/vufind/local/config/vufind/config.ini

# Besides installing dependencies, set MySQL credentials correctly.
sed -i 's#mysql://.*#mysql://'"$MYSQL_USER_NAME"':'"$MYSQL_USER_PASSWORD"'@'"$MYSQL_HOST_NAME"'/'"$MYSQL_DATABASE_NAME"'"#g' /usr/local/vufind/local/config/vufind/config.ini

# Fetch mappings used for linking to iDAI.publications
/usr/local/vufind/local/iDAI.world/fetchMappings.sh

# vendor directory is created while installing dependencies using composer, if the directory is missing run VuFind's
# installation procedure.
if [ ! -d "vendor" ]; then

    # Install dependencies using composer.
    EXPECTED_SIGNATURE="$(wget -q -O - https://composer.github.io/installer.sig)"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_SIGNATURE="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
    then
        >&2 echo 'ERROR: Invalid installer signature'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php
    rm composer-setup.php

    php composer.phar install
fi

rm /usr/local/vufind/local/httpd-vufind.conf;

if [ "$LOCAL_SOLR" = "true" ]; then
    echo "Setting up local Solr-Instance.";

    cp /usr/local/vufind-configs/httpd-vufind.conf /usr/local/vufind/local/httpd-vufind.conf;

    if [[ -f  /etc/apache2/conf-enabled/vufind.conf ]]; then
        rm /etc/apache2/conf-enabled/vufind.conf
    fi
    ln -s /usr/local/vufind/local/httpd-vufind.conf /etc/apache2/conf-enabled/vufind.conf

    export SOLR_ADDITIONAL_START_OPTIONS="-force" # starting as root gets blocked without -force option

    if [ "$LOCAL_SOLR_USE_SAMPLE_DATA" = "true" ]; then

        echo "Using sample data, deleting existing index."
        rm -rf /usr/local/vufind/solr/vufind/biblio/index
        /usr/local/vufind/solr.sh start SOLR_ADDITIONAL_START_OPTIONS "-force"
        # Apache  has to be running for import (provides redirect proxy)
        service apache2 start
        /import/sample_import.sh
        service apache2 stop

        /usr/local/vufind/solr.sh stop
        echo "Done importing sample data."
    fi

    /usr/local/vufind/solr.sh start SOLR_ADDITIONAL_START_OPTIONS "-force"

else
    # Proxy Solr queries to one of the development servers (no local Solr used in this setup)...
    echo "Using proxied Solr-Instance (redirecting search to 195.37.32.11).";
    cp /usr/local/vufind-configs/httpd-vufind-dev-local.conf /usr/local/vufind/local/httpd-vufind.conf;

    if [[ -f  /etc/apache2/conf-enabled/vufind.conf ]]; then
        rm /etc/apache2/conf-enabled/vufind.conf
    fi
    ln -s /usr/local/vufind/local/httpd-vufind.conf /etc/apache2/conf-enabled/vufind.conf
fi


echo "Starting apache2..."
/usr/sbin/apache2ctl -DFOREGROUND
