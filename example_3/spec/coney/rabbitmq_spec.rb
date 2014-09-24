require 'spec_helper'

context "coney" do
  describe command('hostname') do
    it { should return_stdout('coney') }
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
    describe command('/usr/sbin/rabbitmqctl cluster_status | grep running_nodes') do
      it { should return_stdout /running_nodes/ }
      it { should return_stdout /rabbit@coney/ }
      it { should return_stdout /rabbit@rabbit/ }
    end
  end

  describe "Non-mirrored queue" do
    describe "localhost" do
      describe command('/vagrant/send.py -s localhost') do
        it { should return_stdout /\[x\] Sent 'Hello World!'/ }
      end
      describe command('/vagrant/receive_once.py -s localhost') do
        it { should return_stdout /Hello World!/ }
      end
    end
    describe "Rabbit" do
      describe command('/vagrant/send.py -s rabbit') do
        it { should return_stdout /\[x\] Sent 'Hello World!'/ }
      end
      describe command('/vagrant/receive_once.py -s rabbit') do
        it { should return_stdout /Hello World!/ }
      end
    end
  end

  describe "Mirrored queue" do
    describe command('/vagrant/send-mirrored.py') do
      it { should return_stdout /\[x\] Sent 'Hello Mirror World!'/ }
    end
  end

end
