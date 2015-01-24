# class marathon::package
class marathon::package (
  $package = 'marathon',
  $ensure = 'installed',
) {

  package { $package:
    ensure => $ensure,
    notify => Class['Marathon::Service'],
  }
}
