require 'spec_helper'

context "coney" do
  describe command('hostname') do
    its(:stdout) { should match /coney/ }
  end

  describe "Services" do
    describe package('rabbitmq-server') do
      it { should be_installed }
    end

    describe service('rabbitmq-server') do
      it { should be_enabled   }
      it { should be_running   }
    end
  end

  describe "Ports" do
    describe port(15672) do
      it { should be_listening }
    end

    describe port(5672) do
      it { should be_listening }
    end
  end

  describe "Cluster status" do
    describe command('/usr/sbin/rabbitmqctl cluster_status | /bin/grep running_nodes') do
      its(:stdout) { should match /running_nodes/ }
      its(:stdout) { should match /rabbit@coney/ }
      its(:stdout) { should match /rabbit@rabbit/ }
    end
  end

  describe "Non-mirrored queue" do
    describe "localhost" do
      describe command('/vagrant/send.py -s localhost') do
        its(:stdout) { should match /\[x\] Sent 'Hello World!'/ }
      end
      describe command('/vagrant/receive_once.py -s localhost') do
        its(:stdout) { should match /Hello World!/ }
      end
    end
    describe "Rabbit" do
      describe command('/vagrant/send.py -s rabbit') do
        its(:stdout) { should match /\[x\] Sent 'Hello World!'/ }
      end
      describe command('/vagrant/receive_once.py -s rabbit') do
        its(:stdout) { should match /Hello World!/ }
      end
    end
  end

  describe "Mirrored queue" do
    describe command('/vagrant/send-mirrored.py') do
      its(:stdout) { should match /\[x\] Sent 'Hello Mirror World!'/ }
    end
  end
end
