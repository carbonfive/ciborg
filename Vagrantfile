Vagrant::Config.run do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/#{config.vm.box}.box"
  config.vm.network :hostonly, "192.168.33.10"

  config.vm.provision :shell, :inline => "grep -q ubuntu /etc/passwd || sudo -n useradd -m ubuntu -G sudo,admin -s /bin/bash"

  config.vm.provision :shell, :inline => "test -d /home/ubuntu/.ssh || sudo -n mkdir /home/ubuntu/.ssh"
  config.vm.provision :shell, :inline => "sudo -n chmod 0700 /home/ubuntu/.ssh"

  config.vm.provision :shell do |shell|
    shell.inline = "sudo -n echo $@ > /home/ubuntu/.ssh/authorized_keys"
    ssh_key = File.join(File.dirname(__FILE__), 'spec', 'fixtures', 'ssh_keys', 'vagrant_test_key.pub')
    shell.args = File.read(ssh_key)
  end

  config.vm.provision :shell, :inline => "sudo -n chown -R ubuntu /home/ubuntu/.ssh"
end
