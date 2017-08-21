#!/bin/bash
# make language files writable
cd /var/www/html && chmod 666 inc/languages/english/*.php inc/languages/english/admin/*.php

# make public folders writable
cd /var/www/html && chmod 777 cache/ cache/themes/ uploads/ uploads/avatars/ admin/backups/

# delete installation directory
rm -rf /var/www/html/install

# Set config variables
sed -i -e 's/DATABASE/'"$X_DATABASE_NAME"'/g' /var/www/html/inc/config.php
sed -i -e 's/HOSTNAME/'"$X_DATABASE_URI"'/g' /var/www/html/inc/config.php
sed -i -e 's/USERNAME/'"$X_DATABASE_USER"'/g' /var/www/html/inc/config.php
sed -i -e 's/PASSWORD/'"$X_DATABASE_PASS"'/g' /var/www/html/inc/config.php
sed -i -e 's/BB_NAME/'"$X_APPLICATION_NAME"'/g' /var/www/html/inc/settings.php
sed -i -e 's/BB_URL/'"$X_ELB_HOSTNAME"'/g' /var/www/html/inc/settings.php
