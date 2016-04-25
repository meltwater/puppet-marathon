# == Class: marathon::service
#
# Starts the service.
#
class marathon::service {

  $provider = $marathon::init_style ? {
    'sysv'  => 'redhat',
    default => $marathon::init_style
  }

  service { 'marathon':
    ensure     => $marathon::service_ensure,
    enable     => $marathon::service_enable,
    hasrestart => true,
    hasstatus  => true,
    provider   => $provider,
    subscribe  => [File['marathon-conf'], Package['marathon']],
    require    => Class['marathon::install'],
  }
}
