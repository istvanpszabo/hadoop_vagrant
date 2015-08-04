VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do | config |

	#variables here
	ipaddress = '192.168.1.1'
	slaves = 2
	slaveport = 24201

	config.vm.box = 'ubuntu/trusty64'

# master configuration	
	config.vm.define :master, primary: true do | master |
	
		master.vm.network 'private_network', ip:ipaddress + '9'
		
		master.vm.network 'forwarded_port', guest:50700, host:24200
		
		master.vm.hostname = 'master'
		
		master.vm.provider 'virtualbox' do | v |
			v.name = 'master'
			v.memory = 512
		end
		
		master.vm.provision :puppet do | puppet|
			puppet.facter = { "fqdn" => "local.machine", "hostname" => "master" }
			puppet.manifests_path = "manifests"
			puppet.manifest_file = "master.pp"
			puppet.module_path = "modules"
		end
		
	end

	
# slaves configuration
#	1.upto(slaves) do | index |
#		slavename = 'slave-' + index.to_s
#		
#		config.vm.define slavename do | slave |
#			
#			slave.vm.network 'private_network', ip:ipaddress + index.to_s
#			
#			slave.vm.network 'forwarded_port', guest: 50701, host:slaveport + index
#			
#			slave.vm.hostname = 'slave-'+index.to_s
#			
#			slave.vm.provider 'virtualbox' do | v1 |
#				v1.name = 'slave-' + index.to_s
#				v1.memory = 512
#			end
#		end
#	end
	
end