# == Class: marathon::service
#
# Starts the service.
#
class marathon::service {

  $provider = $marathon::init_style ? {
    'sysv'  => 'init',
    default => $marathon::init_style
  }

  service { 'marathon':
    ensure    => $marathon::service_ensure,
    enable    => $marathon::service_enable,
    provider  => $provider,
    subscribe => File['marathon-conf'],
    require   => Class['marathon::install']
  }
}
