# == Class: marathon::service
#
# Starts the service.
#
class marathon::service {

  service { 'marathon':
    ensure    => $marathon::service_ensure,
    enable    => $marathon::service_enable,
    provider  => $marathon::init_style,
    subscribe => File['marathon-conf'],
    require   => Class['marathon::install']
  }
}
