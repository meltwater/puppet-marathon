# == Class marathon::install
#
# Installs marathon.
#
class marathon::install {

  package { $marathon::package:
    ensure => $marathon::package_ensure,
  }

  if $marathon::install_java {
    package { $marathon::java_version:
      ensure => installed,
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
          mode    => '0644',
          owner   => 'root',
          group   => 'root',
          content => template('marathon/marathon.systemd.erb'),
        }
      }
      'sysv' : {
        file { '/etc/init.d/marathon':
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
