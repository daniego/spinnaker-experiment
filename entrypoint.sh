#!/bin/bash
set -x
apt-get install apt-transport-https wget -y

# net-tools
# echo `ifconfig eth0|grep inet|awk {'print $2'}` `hostname` > /etc/hosts

hal config provider kubernetes enable

# hal config deploy edit --type localdebian

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint $MINIO_ENDPOINT \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key # will be read on STDIN to avoid polluting your
                        # ~/.bash_history with a secret

hal config storage edit --type s3
hal config version edit --version $SPINNAKER_VERSION
hal deploy apply

hal deploy connect

sed -i '1s/^/Listen 9000\n/' /etc/apache2/sites-enabled/spinnaker.conf
sed -i 's/localhost/*/g' /etc/apache2/sites-enabled/spinnaker.conf
apachectl restart

tail -f /var/log/apache2/*
