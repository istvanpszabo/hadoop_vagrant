class hadoopsetup{

	$hadoop_version = "2.7.0"
	$hadoop_home = "/hadoop_files/hadoop-${hadoop_version}"
	$hadoop_tar = "hadoop-${hadoop_version}.tar.gz"
	$hadoop_conf = "${hadoop_home}/conf"
	$hadoop_logs_base = "$hadoop_home/logs"
	$hadoop_log  = "${hadoop_logs_basedir}/hadoop"
	$yarn_log  = "${hadoop_logs_basedir}/yarn"
	$mapred_log  = "${hadoop_logs_basedir}/mapred"
  	
  	
  	file{ ["/srv/hadoop/",  "/srv/hadoop/namenode", "/srv/hadoop/datanode/"]:
 		ensure => "directory",
    	owner => "hdfs",
		group => "hadoop"
  	}
  	
	file{ "/hadoop_files":
		ensure => "directory",
	}

	file{ "/hadoop_files/${hadoop_version}":
		ensure => "directory",
		require => File["/hadoop_files"]
	}	
	
  	# the mirror is the suggested one by the apache site, location: DE
	# this downloads the tar to every node, probably the location can be changed to /vagrant and then it will be downloaded once and copied from there
	exec{ "download_hadoop":
    	command => "wget apache.mirror.digionline.de/hadoop/common/hadoop-${hadoop_version}/$hadoop_tar -O ${hadoop_home} --read-timeout=5 --tries=0",
    	timeout => 1800,
    	path => $path,
    	#creates => "/vagrant/$hadoop_tar",
    	require => [Package["openjdk-7-jdk"], File["/hadoop_files/${hadoop_version}"]]
	}
	
	# untar hadoop files
	exec{ "untar_hadoop" :
    	command => "tar xf ${hadoop_home} -C /hadoop_files",
    	path => $path,
    	require => Exec["download_hadoop"]
	}
	
	exec { "hadoop_conf_permissions" :
		command => "chown -R vagrant ${hadoop_conf}",
		path => $path,
		require => Exec["untar_hadoop"]
	}
	
	file{ $hadoop_logs_base:
		ensure => "directory",
		group => "hadoop",
		require => Exec["untar_hadoop"]
	}

	file { "${hadoop_conf}":
		ensure => "directory",
		require => Exec["untar_hadoop"]
	}
	
	file {$hadoop_log:
		ensure => "directory",
		owner => "hdfs",
		group => "hadoop",
		require => File[$hadoop_logs_base]
	}

	file {$yarn_log:
		ensure => "directory",
		owner => "yarn",
		group => "hadoop",
		require => File[$hadoop_logs_base]
	}
	
	file {$mapred_log:
		ensure => "directory",
		owner => "mapred",
		group => "hadoop",
		require => File[$hadoop_logs_base]
	}
	
	file { "${hadoop_conf}/slaves":
		source => "puppet:///modules/hadoopsetup/slaves",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}

	# creates the cluster file
	file { "${hadoop_home}/bin/prepare-cluster.sh":
		source => "puppet:///modules/hadoopsetup/prepare-cluster.sh",
		mode => 755,
		owner => vagrant,
		group => root,
		require => Exec["untar_hadoop"]
	}
	
	# copy the modified start-all script
	file { "${hadoop_home}/bin/start-all.sh":
      source => "puppet:///modules/hadoopsetup/start-all.sh",
      mode => 755,
      owner => vagrant,
      group => root,
      require => Exec["untar_hadoop"]
	}
	
	# copy the modified stop-all cluster stop script
	file { "${hadoop_home}/bin/stop-all.sh":
		source => "puppet:///modules/hadoopsetup/stop-all.sh",
		mode => 755,
		owner => vagrant,
		group => root,
		require => Exec["untar_hadoop"]
	}
	
	# deploy the overwritten masters file
	file { "${hadoop_conf}/masters":
		source => "puppet:///modules/hadoopsetup/masters",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}

	file { "${hadoop_conf}/core-site.xml":
		source => "puppet:///modules/hadoopsetup/core-site.xml",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}

	file { "${hadoop_conf}/mapred-site.xml":
		source => "puppet:///modules/hadoopsetup/mapred-site.xml",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}
	
	file { "${hadoop_conf}/hdfs-site.xml":
		source => "puppet:///modules/hadoopsetup/hdfs-site.xml",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}

	file { "${hadoop_conf}/hadoop-env.sh":
		source => "puppet:///modules/hadoopsetup/hadoop-env.sh",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}
 
	file { "${hadoop_conf}/yarn-site.xml":
		source => "puppet:///modules/hadoopsetup/yarn-site.xml",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}
	
	file { "${hadoop_conf}/yarn-env.sh":
		source => "puppet:///modules/hadoopsetup/yarn-env.sh",
		mode => 644,
		owner => vagrant,
		group => root,
		require => File["${hadoop_conf}"]
	}

	# this will create all of the necessary environment variables
	file { "/etc/profile.d/hadoop-path.sh":
		content => template("hadoopsetup/hadoop-path.sh.erb"),
		owner => vagrant,
		group => root,
	}
	
}