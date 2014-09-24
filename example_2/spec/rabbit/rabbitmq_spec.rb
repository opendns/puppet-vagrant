# Boilerplate required by ServerSpec
require 'spec_helper'

# And now a test!
describe package('rabbitmq-server') do
  it { should be_installed }
end

describe service('rabbitmq-server') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(15672) do
  it { should be_listening }
end

describe port(5672) do
  it { should be_listening }
end

describe command('/vagrant/send.py -s localhost') do
  it { should return_stdout /\[x\] Sent 'Hello World!'/ }
end

describe command('/vagrant/receive_once.py -s localhost') do
  it { should return_stdout /Hello World!/ }
end
