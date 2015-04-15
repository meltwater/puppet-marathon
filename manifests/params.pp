# == Class: marathon::params
#
# Parameters for marathon class
#
class marathon::params {
  $package           = 'marathon'
  $package_ensure    = 'latest'
  $install_java      = true
  $java_version      = 'java-1.7.0-openjdk'
  $bin_path          = '/usr/local/bin'

  $init_style = $::operatingsystem ? {
    'Ubuntu'             => $::lsbdistrelease ? {
      /(10|12|14)\.04/ => 'upstart',
      default => undef
    },
    /CentOS|RedHat|OracleLinux/      => $::operatingsystemmajrelease ? {
      /(4|5|6)/ => 'sysv',
      default   => 'systemd',
    },
    'Fedora'             => $::operatingsystemmajrelease ? {
      /(12|13|14)/ => 'sysv',
      default      => 'systemd',
    },
    default => undef
  }
}
