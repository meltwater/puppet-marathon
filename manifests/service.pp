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
    ensure     => $marathon::service_ensure,
    enable     => $marathon::service_enable,
    hasrestart => true,
    hasstatus  => true,
    provider   => $provider,
    subscribe  => [File['marathon-conf'], Package[$marathon::package]],
    require    => Class['marathon::install'],
  }
}
