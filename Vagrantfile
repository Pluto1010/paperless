# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.33.31"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = 512
     vb.cpus = 2
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
    echo 'deb http://packages.elastic.co/elasticsearch/1.5/debian stable main' | sudo tee /etc/apt/sources.list.d/elasticsearch.list

    sudo apt-get update
    sudo apt-get install -y openjdk-7-jre supervisor htop

    cd /opt

    function checkTika {
      echo 'ac0b1207284b7bd591acb0b7453081cbb1ea143c650678927ffe1463be659305  tika-server-1.8.jar' | sha256sum -c
      return $?
    }

    if ! checkTika; then
      wget --progress=bar:force -O tika-server-1.8.jar http://repo1.maven.org/maven2/org/apache/tika/tika-server/1.8/tika-server-1.8.jar

      checkTika
    fi;

    cd /
    cat <<EOF > /usr/local/bin/tika-rest-server
#!/bin/bash
exec java  -jar /opt/tika-server-1.8.jar "\\$@"
EOF
    chmod +x /usr/local/bin/tika-rest-server

    cat <<EOF > /etc/supervisor/conf.d/tika.conf
[program:tika]
command=/usr/local/bin/tika-rest-server -h 0.0.0.0 -C all
redirect_stderr=true
EOF
    service supervisor restart
  SHELL
end
