# == Class: marathon::service
#
# Starts the service.
#
class marathon::service {

  service { 'marathon':
    ensure  => $marathon::service_ensure,
    enable  => $marathon::service_enable,
  }
}
