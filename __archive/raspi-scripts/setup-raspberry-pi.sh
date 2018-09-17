# this is actually not a script rather a semiscript
# thus, prevent this file to be actually run as a script...
# author: langenhagen
# verions: 17-08-04

echo 'semiscript'
exit 0


#####################################################################
# install raspian

## download image from:
https://www.raspberrypi.org/downloads/raspbian/

## follog guidelines here:
https://www.raspberrypi.org/documentation/installation/installing-images/mac.md

## aka do
diskutil list
diskutil unmountDisk /dev/disk<disk# from diskutil>        # repeat till it works^^
sudo dd bs=1m if=image.img of=/dev/rdisk<disk# from diskutil>

#####################################################################
# init raspberry pi

## for the first run, follow the guidelines here:
https://www.raspberrypi.org/forums/viewtopic.php?t=4751

### aka do:
user: pi
pass: raspberry

### then run
sudo raspi-config


#####################################################################
############# go via ssh from here on if possible... ################
#####################################################################


#####################################################################
# setup WIFI suring Your installation. maybe You have to...
https://www.raspberrypi.org/documentation/configuration/wireless/wireless-cli.md

## aka add the following to (you might have to wait a few minutes after that):
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf

network={
    ssid="testing"
    psk="testingPassword"
}

## run for verification (inet addr: should have values added)
ifconfig wlan0

#####################################################################
# install stuff

sudo apt-get update; \
sudo apt-get upgrade; \
sudo apt-get -y install ntfs-3g; \
sudo apt-get -y install vim; \
sudo apt-get -y install fish; \
sudo apt-get -y install git; \
sudo apt-get -y install tig; \
sudo apt-get -y install rsync; \
sudo apt-get -y install rsnapshot; \
sudo apt-get -y install ddclient; \
sudo apt-get -y install mc; \
sudo apt-get -y install ssh; \
sudo apt-get -y install wget; \
sudo apt-get -y install tree; \
sudo apt-get -y install mariadb-server; \
sudo apt-get -y install php5; \
sudo apt-get -y install php5-mysql; \          # installs pdo_mysql plugin in php?
sudo apt-get -y install apache2; \
sudo apt-get -y install libapache2-mod-php5; \
sudo apt-get -y install php5-gd; \
sudo apt-get -y install php5-json; \
sudo apt-get -y install; php5-curl \
sudo apt-get -y install php5-intl; \
sudo apt-get -y install php5-mcrypt; \
sudo apt-get -y install php5-imagick; \
sudo apt-get -y install redis-server; \
sudo apt-get -y install php5-redis; \
sudo apt-get -y install php5-apcu;


#####################################################################
# copy script files
mkdir -p /home/pi/scripts; mkdir -p /home/pi/rsnapshot_logs


## copy script files manually e.g. with filezilla


#####################################################################
# setup git
git config --global user.email "andreas@langenhagen.cc" ; \
git config --global user.name "Andreas Langenhagen"


#####################################################################
# setup dotfiles
cd /home/pi/ ; git clone https://github.com/langenhagen/dotfiles.git
git checkout -b raspi ; git pull origin raspi


#####################################################################
# link dotfiles
cd /home/pi/dotfiles ; bash link-files.sh


#####################################################################
# mount directories

## check for current mountable drives and where to mount them (e.g. /dev/sda1)
sudo blkid
sudo fdisk -l

## create mount points
sudo mkdir /mnnt/barn_ext/ ; sudo mkdir /mnt/barn_bak/

## mount
sudo mount /dev/sda1 /mnt/barn_bak/ # mount drive 1
sudo mount /dev/sdb1 /mnt/barn_ext/ # mount drive 2

### unmounting if You need to
sudo umount /mnt/barn_ext/


## add the following to /etc/fstab         (with spaces instead of tabs)  :
sudo vim /etc/fstab

LABEL=Barn_External_I       /mnt/barn_ext   ntfs    defaults          0       0
LABEL=Barn_Ext_II           /mnt/barn_bak   ntfs    defaults          0       0
# the following one worked on the first installation, but not on the second one:
# LABEL=Barn_External_I       /mnt/barn_ext   ntfs    nofail,uid=33,gid=33,umask=0027,dmask=0027,noatim$

## danach
sudo reboot


#####################################################################
# install and setup MariaDB

## from:
https://doc.owncloud.org/server/latest/admin_manual/configuration_database/linux_database_configuration.html


## ensure you have pdo_mysql extension installed and enabled
## check whether pdo extensions are enabled
php -i|grep PDO


## ensure that the mysql.default_socket points to the correct socket
## check whether the default socket is set: mysql.default_socket=/var/lib/mysql/mysql.sock  # Debian squeeze: /var/run/mysqld/mysqld.sock
php -i|grep socket


## for owncloud,
## disable binary logging in mariadb and ensure that in:
sudo vim /etc/mysql/my.cnf

log_bin # is commented out log bin

## create a database and run the following in the mysql/mariadb prompt
mysql -uroot -p

CREATE DATABASE IF NOT EXISTS owncloud;
GRANT ALL PRIVILEGES ON owncloud.* TO 'username'@'localhost' IDENTIFIED BY 'password';
quit


#####################################################################
# use redis to handle in-memory file caching in owncloud

## check whether redis is running and get its port
ps ax | grep redis


#####################################################################
# install owncloud

## generally, follow:
https://doc.owncloud.org/server/9.1/admin_manual/installation/source_installation.html
https://doc.owncloud.org/server/9.1/admin_manual/installation/command_line_installation.html

## get owncloud
cd /var/www/
sudo wget https://download.owncloud.org/community/owncloud-10.0.2.tar.bz2
sudo tar -xjf owncloud-10.0.2.tar.bz2

## create a file:
sudo vim /etc/apache2/sites-available/owncloud.conf

```
Alias /owncloud "/var/www/owncloud/"


<Directory /var/www/owncloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/owncloud
 SetEnv HTTP_HOME /var/www/owncloud
 Satisfy Any
</Directory>
```

## create a symlink
sudo ln -s /etc/apache2/sites-available/owncloud.conf /etc/apache2/sites-enabled/owncloud.conf


## setup apache
sudo a2enmod rewrite ; sudo a2enmod headers ; sudo a2enmod env ; sudo a2enmod dir ; sudo a2enmod mime ; \
sudo a2enmod ssl ; sudo a2ensite default-ssl ; \
sudo service apache2 restart ; sudo systemctl daemon-reload \

## set the data directory owner to var-www
sudo chown -R www-data:www-data /var/www/owncloud/

## create an appropriate config file:
## the config file was influenced by:
https://www.techandme.se/how-to-configure-redis-cache-in-ubuntu-14-04-with-owncloud/

cd /var/www/owncloud/config
sudo touch config.php

```
<?php
$CONFIG = array (
  'passwordsalt' => 'FJRYNBU0To7tWq6wzVeoPj7XUQ6BvT',
  'secret' => 'FoTqZTx5BNmJnZMiv2L58KVxsIeUQbZ+Tq23RVpDKJNFwZhl',
  'trusted_domains' =>
  array (
    0 => 'localhost',
  ),
  'datadirectory' => '/mnt/barn_ext/oc',
  'overwrite.cli.url' => 'http://localhost',
  'dbtype' => 'mysql',
  'version' => '10.0.2.1',
  'dbname' => 'owncloud',
  'dbhost' => 'localhost',
  'dbtableprefix' => 'oc_',
  'dbuser' => 'oc_admin',
  'dbpassword' => '/MWrtLsvjdYfLF75yady5tF0loKJ1s',
  'logtimezone' => 'UTC',
  'installed' => true,
  'instanceid' => 'oc2be9iuzbb1',
  'filelocking.enabled' => true,
  'memcache.local' => '\OC\Memcache\APCu',
  'redis' => array(
     'host' => '/var/run/redis/redis.sock',
     'port' => 0,
      ),
);
```


## install owncloud
cd /var/www/owncloud ; \
sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "owncloud"  --database-user "root" --database-pass "MYMARIADBPASS" --admin-user "admin" --admin-pass "MYMARIADBPASS"


## set the ownership of the external files to the owncloud user
## chown and chmod does not work since our external hard drives are ntfs. we solve this at mount time
cd /var/www/owncloud ; \
sudo -u www-data chown -R www-data:www-data . ; \
sudo -u www-data chmod -R 0750 .

## change the fstab according to the following
sudo vim /etc/fstab

#####################################################################
# change the ntfs mount to be able to mount according to the chmod/chown specifiactions

# LABEL=Barn_External_I       /mnt/barn_ext   ntfs    defaults          0       0
LABEL=Barn_External_I       /mnt/barn_ext   ntfs    nofail,uid=33,gid=33,umask=0027,dmask=0027,noatim$

### to step through all un-permitted things, You can:
sudo su

## put files into owncloud

## re-scan owncloud
cd /var/www/owncloud
sudo -u www-data php occ files:scan barn


#####################################################################
# set up rsnapshot
## adjust the  sudo vim /etc/rsnapshot.conf     (SPACES MUST BE TABS!!!)       :

snapshot_root   /mnt/barn_bak/_bak/
no_create_root  1
cmd_cp          /bin/cp
cmd_rm          /bin/rm
cmd_rsync       /usr/bin/rsync

#retain         hourly  6
retain          daily   10
#retain         weekly  4
retain          monthly 12

verbose         2
loglevel        3

exclude         /home/pi/rsnapshot_logs/

###############################
### BACKUP POINTS / SCRIPTS ###
###############################


# My Barns Own
backup  /mnt/barn_ext/oc/barn/files/    barn/

# LOCALHOST
backup  /home/          localhost/
backup  /etc/           localhost/
backup  /usr/local/     localhost/



## dann probiere:
sudo rsnapshot configtest


#####################################################################
# set up dyndns
sudo vim /etc/ddclient.conf

pid=/var/run/ddclient.pid
protocol=dyndns2
use=web
ssl=yes
server=dyndns.strato.com/nic/update
login=langenhagen.cc
mx=go.langenhagen.cc
password='MYDNDNSPASS'
go.langenhagen.cc


## test the ddclient settings with, should print SUCCESS
sudo ddclient -daemon=0 -debug -verbose -noquiet
sudo reboot

# this one updates the dynamic dns:
# sudo  /usr/sbin/ddclient --force
# you might also have to change the ip address inside the    /var/www/owncloud/config/config.php

#####################################################################
# set up crontab for automatic backups         (use TABS in crontab!)

sudo vim /etc/crontab

0 5     * * *   root    /bin/bash /home/pi/scripts/backup_owncloud_daily.sh
0 2     1 * *   root    /bin/bash /home/pi/scripts/backup_owncloud_monthly.sh
# leave the ddclient update out since unnecessary updates are considered abusive
#0 11    * * *   root    /usr/sbin/ddclient --force


#####################################################################
# disable wifi
sudo vim /etc/modprobe.d/raspi-blacklist.conf  # file might not yet exist

blacklist brcmfmac
blacklist brcmutil


#####################################################################
# disable bluetooth
sudo vim /boot/config.txt

dtoverlay=pi3-disable-bt

## danach
sudo reboot


#####################################################################
# do some checks

## time / date
date

## check backups