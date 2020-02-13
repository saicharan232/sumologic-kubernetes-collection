# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/bionic64'
  config.vm.box_check_update = false
  config.vm.host_name = 'sumologic-kubernetes-collection-dev.vagrantup.com'

  config.vm.network :forwarded_port, guest: 18080, host: 18080
  config.vm.network :forwarded_port, guest: 51820, host: 51820
  config.vm.network :forwarded_port, guest: 8443, host: 8443

  config.vm.network :private_network, ip: "192.168.33.33"

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    vb.cpus = 8
    vb.memory = 16384
    vb.name = 'sumologic-kubernetes-collection-dev'
    config.disksize.size = '16GB'
  end
  config.vm.synced_folder "deploy/helm", "/helm"
  config.vm.provision 'file', source: 'vagrant', destination: 'vagrant'
  config.vm.provision 'file', source: 'deploy/helm', destination: 'helm'
  config.vm.provision 'shell', path: 'vagrant/provision.sh'
  config.vm.provision 'shell', path: 'vagrant/setup.sh'

end
