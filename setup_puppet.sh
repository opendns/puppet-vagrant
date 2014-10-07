#!/bin/bash

if [ -d ~/puppet/modules ] ; then
    echo "Whoops, looks like there's already ~/puppet/modules."
    echo "I don't want to cause any problems...edit this script if you want to force things."
    exit
fi

mkdir -p ~/puppet/modules
cd ~/puppet/modules
curl https://forgeapi.puppetlabs.com/v3/files/puppetlabs-stdlib-4.3.2.tar.gz | tar xvzf - 
ln -s puppetlabs-stdlib-4.3.2 stdlib
curl https://forgeapi.puppetlabs.com/v3/files/nanliu-staging-1.0.0.tar.gz | tar xvzf - 
ln -s nanliu-staging-1.0.0 staging
curl https://forgeapi.puppetlabs.com/v3/files/puppetlabs-rabbitmq-4.1.0.tar.gz | tar xvzf -
ln -s puppetlabs-rabbitmq-4.0.0 rabbitmq
curl https://forgeapi.puppetlabs.com/v3/files/puppetlabs-apt-1.6.0.tar.gz | tar xvzf -
ln -s puppetlabs-apt-1.6.0 apt
