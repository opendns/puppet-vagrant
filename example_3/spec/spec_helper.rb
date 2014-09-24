require 'serverspec'
require 'pathname'
require 'net/ssh'

include SpecInfra::Helper::Ssh
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    block = self.class.metadata[:block]
    if RUBY_VERSION.start_with?('1.8')
      file = block.to_s.match(/.*@(.*):[0-9]+>/)[1]
    else
      file = block.source_location.first
    end
    host  = File.basename(Pathname.new(file).dirname)
    if c.host != host
      c.ssh.close if c.ssh
      c.host  = host
      options = Net::SSH::Config.for(c.host)
      user    = options[:user] || Etc.getlogin
      vagrant_up = `vagrant up #{host}`
      flag = 0
      # This was originally "vagrant ssh-config --host #{host}", and I
      # think the idea was that it would give you the config for just
      # the one host.  However, the ssh-config command doesn't appear
      # to behave like that -- maybe it's a bug, but it gives the
      # config for *both* hosts but both labelled as whatever host you
      # provide (so you get two configs labelled "Coney", one correct
      # and one actually for Rabbit).  Very annoying.  Thus, this crap
      # code to watch for the config you want.
      #
      # Submitted to Vagrant:  https://github.com/mitchellh/vagrant/issues/4478
      # Doesn't look like ServerSpec has bug tracker. :-(
      config = `vagrant ssh-config`
      if config != ''
        config.each_line do |line|
          if match = /Host (.*)$/.match(line)
            if match[1] == host
              flag = 1
            else
              flag = 0
            end
          end
          if flag == 1
            if match = /HostName (.*)/.match(line)
              host = match[1]
            elsif  match = /User (.*)/.match(line)
              user = match[1]
            elsif match = /IdentityFile (.*)/.match(line)
              options[:keys] =  [match[1].gsub(/"/,'')]
            elsif match = /Port (.*)/.match(line)
              options[:port] = match[1]
            end
          else
          end
        end
      end
      c.ssh   = Net::SSH.start(host, user, options)
    end
  end
end
