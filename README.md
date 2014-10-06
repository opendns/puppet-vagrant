# Testing Puppet modules with Serverspec and Vagrant

This repo contains the code samples for the OpenDNS Engineering blog
post FIXME, which can be found at FIXME.

## Requirements

* [Vagrant](http://downloads.vagrantup.com/)
* The Vagrant box "hashicorp/precise64"; it'll be installed
  automagically if you don't have it already
* ServerSpec, which implies a Ruby dev environment to run it in (I use
  FIXME:link rbenv).

## Examples

* The example_1 directory simply tests Puppet code to install the
rabbitmq-server package on a single VM.  This is pretty simple stuff,
but it's a good demonstration of how simple it is to add tests right
from the start.

* The example_2 directory tests an installation of RabbitMQ using the
  FIXME:link Puppetlabs RabbitMQ module from Puppetforge.  It
  exercises a the server with couple of Python scripts (based on the
  RabbitMQ documentation) that use FIXME:link Pika.  These scripts
  send a message (send.py) and receive the message (receive_once.py).

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

## A note about ServerSpec

There were a few things I tripped over with ServerSpec that are worth
noting.

First off, I kept getting a deprecation warning that looked like this:

```
Deprecation Warnings:

`metadata[:example_group_block]` is deprecated. Use `metadata[:block]`
instead. Called from spec/spec_helper.rb:16:in `yield'.

```

This was with the spec files as created by `serverspec-init`.  The
warning seems to be harmless, but I followed its advice and changed it
like so:

```
--- spec-dist/spec_helper.rb	2014-10-06 11:42:40.000000000 -0700
+++ spec/spec_helper.rb	2014-10-06 11:45:15.000000000 -0700
@@ -13,7 +13,7 @@
     c.sudo_password = ENV['SUDO_PASSWORD']
   end
   c.before :all do
-    block = self.class.metadata[:example_group_block]
+    block = self.class.metadata[:block]
     if RUBY_VERSION.start_with?('1.8')
       file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
     else
 ````

Second, getting serverspec to test two VMs turned out to be harder
than I thought.  If I'm reading the serverspec documentation right, it
should Just Work, but it seems to be running into problems with the
way Vagrant displays SSH configuration for multiple machines.  I've
FIXME:link reported this a bug, but in the meantime I've put a hack in
example_3/spec/spec_helper.rb...it's nor pretty, but it seems to wor
around the problem.

* Download and install
