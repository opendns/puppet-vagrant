<<<<<<< HEAD
# Testing Puppet modules with Serverspec and Vagrant

This repo contains the code samples for the OpenDNS Engineering blog
post FIXME, which can be found at FIXME.

## Requirements

* [Vagrant](http://downloads.vagrantup.com/).  In these examples I use
  the Vagrant box "hashicorp/precise64"; it'll be installed
  automagically if you don't have it already.
* [ServerSpec](http://serverspec.org), which implies a Ruby dev
  environment to run it in; for OS X, I use
  [rbenv](https://github.com/sstephenson/rbenv).
* The following modules from
  [PuppetForge](https://forge.puppetlabs.com):

  * [puppetlabs/rabbitmq](https://forge.puppetlabs.com/puppetlabs/rabbitmq)
  * [puppetlabs/stdlib](https://forge.puppetlabs.com/puppetlabs/stdlib)
  * [puppetlabs/apt](https://forge.puppetlabs.com/puppetlabs/apt)
  * [nanliu/staging](https://forge.puppetlabs.com/nanliu/staging)

See "Preparing Puppet" below for important notes on setup.

## Preparing Puppet

The Puppet modules are expected to be in "~/puppet/modules".  To
prepare that, and to fetch dependencies, you can run setup_puppet.sh
from this git repo.

Alternately, you can specify your own path to these modules by editing
the Vagrantfile in the example directories, and changing
"puppet.module_path" as appropriate; it'll be up to you to make sure
you have the right modules.

## Examples

* The example_1 directory simply tests Puppet code to install the
  rabbitmq-server package on a single VM.  This is pretty simple
  stuff, but it's a good demonstration of how simple it is to add
  configuration management right from the start.

* The example_2 directory tests an installation of RabbitMQ using the
  Puppetlabs RabbitMQ module from Puppetforge.  It exercises a the
  server with couple of Python scripts (based on the RabbitMQ
  documentation) that use
  [Pika](https://pika.readthedocs.org/en/0.9.14/).  These scripts send
  a message (send.py) and receive the message (receive_once.py).

* The example_3 directory is where we go to 11: it creates *two* VMs
  (rabbit and coney), each with their own private IP address; it
  configures mirrored queues; and it tests both individual RabbitMQ
  servers (can I send a message to a host and then pick it up from
  that host?) *and* mirrored queues (can I send a message to one host,
  then pick it up on another?).  Again, the Puppetlabs module is used
  to configure RabbitMQ, although I've also added a couple of scripts
  to set up the mirrored queues (master_setup.sh and
  slave_setup.sh...though master/slave are probably not the right
  terms to use for this kind of mirroring).  The tests run on *both*
  VMs.

## A note about Puppet and module versions

In these examples, the version of Puppet that comes with the Vagrant
boxes we use is 2.7.  That's old, but to simplify things I stuck with
it.  One constraint this added was in the RabbitMQ module;  version
4.0.0 worked fine, but 4.1.0 did not, and gave this error:

```
==> rabbit: Could not autoload rabbitmq_exchange: Could not autoload /tmp/vagrant-puppet-2/modules-0/puppetlabs-rabbitmq-4.1.0/lib/puppet/provider/rabbitmq_exchange/rabbitmqadmin.rb: undefined method `has_command' for Puppet::Type::Rabbitmq_exchange::ProviderRabbitmqadmin:Class at /tmp/vagrant-puppet-2/modules-0/rabbitmq/manifests/init.pp:174 on node rabbit.example.com
````

This
[has been filed as a bug](https://tickets.puppetlabs.com/browse/MODULES-1411),
but as of October 2014 a new version of that module hasn't been
released...so stick with 4.0.0.
=======
puppet-vagrant
==============
>>>>>>> 3e7d04f6bf6c8ce7f39ed2319c2190717d130f56
