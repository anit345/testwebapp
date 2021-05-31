Vagrant.configure("2") do |config|
  config.vm.define "admin" do |instance|
    instance.vm.box = "centos/7"
    instance.vm.network "private_network", ip: "192.168.33.11"
    instance.ssh.insert_key = false
    instance.ssh.private_key_path = ["keys/testVagrantKey", "~/.vagrant.d/insecure_private_key"]
    instance.vm.provision "file", source: "keys/testVagrantKey.pub", destination: "~/.ssh/authorized_keys"
    instance.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
  end

  config.vm.define "web" do |instance|
    instance.vm.box = "centos/7"
    instance.vm.network "private_network", ip: "192.168.33.12"
    instance.vm.network "forwarded_port", guest: 8080, host: 8080
    instance.ssh.insert_key = false
    instance.ssh.private_key_path = ["keys/testVagrantKey", "~/.vagrant.d/insecure_private_key"]
    instance.vm.provision "file", source: "keys/testVagrantKey.pub", destination: "~/.ssh/authorized_keys"
    instance.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
  end

  config.vm.define "db" do |instance|
    instance.vm.box = "centos/7"
    instance.vm.network "private_network", ip: "192.168.33.13"
    instance.ssh.insert_key = false
    instance.ssh.private_key_path = ["keys/testVagrantKey", "~/.vagrant.d/insecure_private_key"]
    instance.vm.provision "file", source: "keys/testVagrantKey.pub", destination: "~/.ssh/authorized_keys"
    instance.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
  end
end
