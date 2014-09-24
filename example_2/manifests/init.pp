class { 'rabbitmq':
    environment_variables   => {
      'RABBITMQ_NODENAME'     => '${hostname}',
      'RABBITMQ_SERVICENAME'  => 'RabbitMQ',
    },
    port                     => '5672',
    config_cluster           => true,
    # MORE FORESHADOWING: We'll need a second machine later on...
    cluster_nodes            => ['rabbit.example.com', 'coney.example.com'],
    cluster_node_type        => 'ram',
    erlang_cookie            => 'SEKRITCOOKIE',
    wipe_db_on_cookie_change => true,
    require                  => File["/usr/local/bin/puppet"],
    config_variables         => { 'loopback_users' => '[]', },
}

# The PuppetLabs module invokes Puppet itself to restart the
# RabbitMQ service when setting the erlang_cookie -- but it sets the
# PATH environment variable manually, and it doesn't include the *real*
# location of puppet in this machine.  The simplest is to symlink it
# to /usr/local/bin, which *is* in PATH.
file { '/usr/local/bin/puppet':
  ensure => "link",
  target => "/opt/vagrant_ruby/bin/puppet",
}
host { 'rabbit.example.com':
  ip           => "192.168.50.100",
  host_aliases => "rabbit",
}
package { "python-pika":
  ensure => installed,
}
