class envsetup{

    # path for global executables
    Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

	# group is required for the users
	# different users required for the different    
	group { "hadoop":
		ensure => "present",
	}
	
	user{ "hduser":
		ensure => "present",
		managehome => "true",
		groups => "hadoop"
	}
	
	user { "hdfs":
		ensure     => "present",
		managehome => "true",
		groups => "hadoop"
  	}
  	
  	user { "yarn":
    	ensure  => "present",
      	managehome => "true",
      	groups => "hadoop"
  	}
  
  	user { "mapred":
    	ensure  => "present",
      	managehome => "true",
      	groups => "hadoop"
  	}
	
	exec{ "apt-get update":
		command => "sudo apt-get update",	
	}
	
	# install the openjdk version 7, this can be overriden and the new version can be installed later on
	package{ "openjdk-7-jdk":
		ensure => present,
		require => Exec["apt-get update"]
	}
	
	# ssh keys should be added to the machine(s)
	# the keys are separately generated and will be placed to the appropriate folder during the installation
	# everything should go to the /root/.ssh directory
	# the public key also needs to be added
	
	file { "/root/.ssh":
    	ensure => "directory",
  	}

  	file { "/root/.ssh/config":
    	source => "puppet:///modules/envsetup/config",
    	mode => 600,
    	owner => root,
    	group => root,
  	}

  	file { "/root/.ssh/id_rsa":
      	source => "puppet:///modules/envsetup/hadoop_key",
      	mode => 600,
      	owner => root,
      	group => root,
  	}

  	file { "/root/.ssh/id_rsa.pub":
      	source => "puppet:///modules/envsetup/hadoop_key.pub",
      	mode => 644,
      	owner => root,
      	group => root,
  	}

  	ssh_authorized_key { "ssh_key":
    	ensure => "present",
    	key    => "AAAAB3NzaC1yc2EAAAADAQABAAABAQCZSimg5FCYIPjQLROPpMCUv+/sR9dYoazaLYbU4MmjShDgVVV+HW46aqC+bSEUq4qMxW5lVwnpBsbnp6Hb8YT/C13+Ojqu6A7+Cqt+N/ix2L4sbaA40CughmZv5+jpySUxnu+KB7KOmTCE95X4kgZ3D3fS32huPa1/C9oYwnHtTHdMXULRRdF2ix245lZK4AmaMBZ3AJ34z+XbQLH5F8UfUNshtfR/fmK0/C/wscRXaH6QsYTylfZWMiJCuOv3FUbu76rQC8K4GgoP81v9N/N377MYPdPCWi+woRHU+V3A0vIdis5pf6dpkKOH55+KVlAiFy6FcNPj087MLXin2N+n",
    	type   => "ssh-rsa",
    	user   => "root",
    	require => File['/root/.ssh/id_rsa.pub']
    }
	
}