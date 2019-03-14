#!/bin/sh

#
# DOes the steps to upgrade owncloud.
# Better run steps manually, If stability is not proven
#
# taken from:
# https://doc.owncloud.org/server/9.1/admin_manual/maintenance/manual_upgrade.html
#
# author: langenhagen

echo "Really?"
echo "<ctrl+c> to escape or enter to proceed"
read THROW_AWAY_VAR


cd /var/www/owncloud
sudo -u www-data php occ maintenance:mode --on

cd /var/www
sudo wget https://download.owncloud.org/community/owncloud-10.0.0.tar.bz2

# shut web server down
sudo killall nginx

sudo mv /var/www/owncloud /var/www/owncloud-old

# unpacs a new owncloud folder
sudo tar xjf owncloud-10.0.0.tar.bz2

sudo cp /var/www/owncloud-old/config/config.php /var/www/owncloud/config/

cd /var/www/
sudo chown -R www-data:www-data .

cd /var/www/owncloud
sudo -u apache php occ upgrade

sudo -u www-data php occ maintenance:mode --off


echo "Better reboot now"
