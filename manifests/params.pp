class marathon::params {
  $package           = 'marathon'
  $package_ensure    = 'latest'
  $version           = '0.7.6'
  $install_java      = true
  $java_version      = 'java-1.7.0-openjdk'

  $init_style = $::operatingsystem ? {
    'Ubuntu'             => $::lsbdistrelease ? {
      /(10|12|14)\.04/ => 'upstart',
      default => undef
    },
    /CentOS|RedHat/      => $::operatingsystemmajrelease ? {
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
