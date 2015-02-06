# == Class marathon::install
#
# Installs marathon.
#
class marathon::install {

  if $marathon::version {
    $marathonpackage = "${marathon::package}-${marathon::version}"
  } else {
    $marathonpackage = $marathon::package
  }

  package { 'marathon':
    ensure => $marathon::package_ensure,
    name   => $marathonpackage,
  }

  if $marathon::install_java {
    package { 'java':
      ensure => installed,
      name   => $marathon::java_version,
    }
  }

  if $marathon::init_style {
    case $marathon::init_style {
      'upstart' : {
        file { '/etc/init/marathon.conf':
          mode    => '0444',
          owner   => 'root',
          group   => 'root',
          content => template('marathon/marathon.upstart.erb'),
        }
        file { '/etc/init.d/marathon':
          ensure => link,
          target => '/lib/init/upstart-job',
          owner  => root,
          group  => root,
          mode   => '0755',
        }
      }
      'systemd' : {
        file { '/lib/systemd/system/marathon.service':
          ensure  => file,
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('marathon/marathon.systemd.erb'),
        }
      }
      'sysv' : {
        file { '/etc/init.d/marathon':
          ensure  => file,
          mode    => '0555',
          owner   => 'root',
          group   => 'root',
          content => template('marathon/marathon.sysv.erb')
        }
      }
      default : {
        fail("I don't know how to create an init script for style ${marathon::init_style}")
      }
    }
  }
}
