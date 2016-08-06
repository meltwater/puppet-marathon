# == Class marathon::install
#
# Installs marathon.
#
class marathon::install {

  if !empty($marathon::master) {
    if is_string($marathon::master) {
      warning('\$marathon::master parameter should be an array of IP addresses with ports, please update your configuration.')
    }

    $master_url = $marathon::master_url_type ? {
      'zookeeper'  => zk_servers_url(
                        $marathon::master,
                        $marathon::master_zk_path,
                        $marathon::zk_default_port
                      ),
      default => join($marathon::master, ',')
    }
  } else {
    $master_url = undef
  }

  if !empty($marathon::zk) {
    if is_string($marathon::zk) {
      warning('\$marathon::zk parameter should be an array of IP addresses with ports, please update your configuration.')
    }
    $zk_url = zk_servers_url(
                $marathon::zk,
                $marathon::zk_path,
                $marathon::zk_default_port
              )
  } else {
    $zk_url = undef
  }

  if $marathon::version {
    $marathonpackage = "${marathon::package}-${marathon::version}"
  } else {
    $marathonpackage = $marathon::package
  }

  if $marathon::manage_repo {
    include ::marathon::repo
    package { 'marathon':
      ensure  => $marathon::package_ensure,
      name    => $marathonpackage,
      require => Class['marathon::repo'],
    }
  } else {
    package { 'marathon':
      ensure => $marathon::package_ensure,
      name   => $marathonpackage,
    }
  }

  if $marathon::install_java {
    package { 'java':
      ensure => installed,
      name   => $marathon::java_version,
    }
  }

  $real_user = $marathon::user

  if $marathon::manage_user == true and
    !defined(User[$marathon::user]) and
    !defined(Group[$marathon::group]) and
    $marathon::user != 'root' {

    ensure_resource('group', $marathon::group, {
      ensure => present,
      name   => $marathon::group
    })
    $real_group = $marathon::group

    ensure_resource('user', $marathon::user, {
      ensure     => present,
      managehome => true,
      shell      => '/sbin/nologin',
      require    => [Group[$marathon::group]],
      groups     => [$marathon::group, 'root']
    })

  } elsif $marathon::manage_user == true and
    !defined(User[$marathon::user]) and
    $marathon::user == 'root' {

    ensure_resource('user', $marathon::user, {
      ensure => present
    })

    $real_group = $marathon::user

  } else {
    $real_group = $marathon::user
  }

  if $marathon::init_style {
    case $marathon::init_style {
      'upstart' : {
        file { 'marathon-conf':
          path    => '/etc/init/marathon.conf',
          mode    => '0444',
          owner   => $real_user,
          group   => $real_group,
          content => template('marathon/marathon.upstart.erb'),
          before  => Service['marathon'],
          notify  => Service['marathon'],
        }
        file { '/etc/init.d/marathon':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => $real_user,
          group  => $real_group,
          mode   => '0755',
          before => Service['marathon'],
          notify => Service['marathon'],
        }
      }
      'systemd' : {
        file { 'marathon-conf':
          ensure  => file,
          path    => '/lib/systemd/system/marathon.service',
          mode    => '0644',
          owner   => $real_user,
          group   => $real_group,
          content => template('marathon/marathon.systemd.erb'),
          before  => Service['marathon'],
          notify  => Service['marathon'],
        }
      }
      'sysv' : {
        file { 'marathon-conf':
          ensure  => file,
          path    => '/etc/init.d/marathon',
          mode    => '0555',
          owner   => $real_user,
          group   => $real_group,
          content => template('marathon/marathon.sysv.erb'),
          before  => Service['marathon'],
          notify  => Service['marathon'],
        }
      }
      'redhat' : {
        file { 'marathon-conf':
          ensure  => file,
          path    => '/etc/init.d/marathon',
          owner   => $real_user,
          group   => $real_group,
          mode    => '0755',
          content => template('marathon/marathon.sysv.erb'),
          before  => Service['marathon'],
          notify  => Service['marathon'],
        }
      }
      default : {
        fail("I don't know how to create an init script \
          for style ${marathon::init_style}")
      }
    }
  }
}
