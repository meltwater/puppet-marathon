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
#   Package ensure. Defaults to latest. Can be used to install
#    a specific version of marathon
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
#   An array of Mesos master URLs.
#   If using zookeeper, the format is ['host1', 'host2'] or
#   ['host1:2181', 'host2:2181']. That will internally
#   be converted to a zk url like ``zk://host1:port,host2:port/mesos`` by using
#   ``master_zk_path``(default: mesos) and ``zk_default_port``(default: 2181)
#   If not using ZooKeeper, a format like ['http://host1', 'http://host2']
#   is also acceptable with ``master_url_type`` set to "http"
#
# [*zk*]
#   An array of ZooKeeper IPs.
#   The format is ['host1', 'host2'] or
#   ['host1:2181', 'host2:2181']. That will internally be converted
#   to a zk url like ``zk://host1:port,host2:port/marathon`` by using
#   ``zk_path``(default: marathon) and ``zk_default_port``(default: 2181)
#
# === Examples
#
#  class { marathon:
#    package_ensure => '0.6.0',
#  }
#
class marathon (
  $package              = $marathon::params::package,
  $package_ensure       = $marathon::params::package_ensure,
  $version              = $marathon::params::version,
  $install_java         = $marathon::params::install_java,
  $java_version         = $marathon::params::java_version,
  $init_style           = $marathon::params::init_style,
  $bin_path             = $marathon::params::bin_path,
  $service_enable       = true,
  $service_ensure       = 'running',
  $extra_options        = undef,
  $master               = ['localhost'],
  $master_url_type      = 'zookeeper',
  $master_zk_path       = 'mesos',
  $zk                   = ['localhost'],
  $zk_path              = 'marathon',
  $zk_default_port      = '2181',
  $manage_user          = false,
  $user                 = 'root',
  $group                = undef,
  $manage_repo          = false
) inherits marathon::params {

  validate_bool($install_java)
  validate_bool($service_enable)
  validate_bool($manage_user)
  validate_bool($manage_repo)

  class { '::marathon::install': } ->
  class { '::marathon::service': }
}
