# == Class: marathon
#
# Installs marathon
#
# === Parameters
#
# [*package*]
#   The package name. Defaults to 'marathon'.
#
# [*package_ensure*]
#   Package ensure. Defaults to latest. Can be used to install a specific version of marathon
#
# [*install_java*]
#   Whether to install the java JDK or not
#
# [*java_version*]
#   The java version to install. Defaults to 1.7 JDK
#
# [*init_style*]
#   What style of init system your system uses.
#
# [*master*]
#   The URL of the Mesos master. The format is a comma-delimited list of of
#   hosts like zk://host1:port,host2:port/mesos. If using ZooKeeper, pay
#   particular attention to the leading zk:// and trailing /mesos!
#   If not using ZooKeeper, standard URLs like http://localhost are also
#   acceptable.
#
# [*zk*]
#   The ZooKeeper URL for storing state.
#
# === Examples
#
#  class { marathon:
#    package_ensure => '0.6.0',
#  }
#
# === Authors
#
# Author Name <william.leese@meltwater.com>
#
class marathon (
  $version              = $marathon::params::version,
  $package              = $marathon::params::package,
  $package_ensure       = $marathon::params::package_ensure,
  $install_java         = $marathon::params::install_java,
  $java_version         = $marathon::params::java_version,
  $init_style           = $marathon::params::init_style,
  $bin_dir              = $marathon::params::bin_dir,
  $service_enable       = true,
  $service_ensure       = 'running',
  $extra_options        = '',
  $master               = 'zk://localhost:2181/mesos',
  $zk                   = 'zk://localhost:2181/marathon',
) inherits marathon::params {

  validate_bool($install_java)
  validate_bool($service_enable)

  class { 'marathon::install': } ->
  class { 'marathon::service': }
}
