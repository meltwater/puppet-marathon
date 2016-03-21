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
#   The URL of the Mesos master. The format is a comma-delimited list of of
#   hosts like zk://host1:port,host2:port/mesos. If using ZooKeeper, pay
#   particular attention to the leading zk:// and trailing /mesos!
#   If not using ZooKeeper, standard URLs like http://localhost are also
#   acceptable.
#
# [*zk*]
#   The ZooKeeper URL for storing state.
#
# [*authenticate*]
#   Use Mesos Authentication (principle and secret) to authenticate with the master
#   default: false
#
# [*auth_principal*]
#   Principal to use when authenticating with Mesos.
#   See Mesos authentication and ACL's for more info.
#
#   Required if authenticate => true
#
# [*auth_secret*]
#   Secret to use for authentication with principal.  It is a good idea to encrypt this,
#   out of the box Mesos is configured to use HTTP.
#
#   Required if authenticate => true
#
# [*secret_file*]
#   File in which to store our secret for slave authentication
#
#   Required if authenticate => true

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
  $package              = $marathon::params::package,
  $package_ensure       = $marathon::params::package_ensure,
  $version              = $marathon::params::version,
  $install_java         = $marathon::params::install_java,
  $java_version         = $marathon::params::java_version,
  $init_style           = $marathon::params::init_style,
  $bin_path             = $marathon::params::bin_path,
  $service_enable       = true,
  $service_ensure       = 'running',
  $extra_options        = '',
  $master               = 'zk://localhost:2181/mesos',
  $zk                   = 'zk://localhost:2181/marathon',
  $manage_user          = false,
  $user                 = 'root',
  $group                = undef,
  $manage_repo          = false,
  $authenticate         = false,
  $secret_file          = '/etc/mesos/marathon.secret',
  $auth_principal       = undef,
  $auth_secret          = undef,
  $auth_role            = undef

) inherits marathon::params {

  validate_bool($install_java)
  validate_bool($service_enable)
  validate_bool($manage_user)
  validate_bool($manage_repo)

  if $authenticate {
    if $auth_principal == undef {
      fail('You must provide a principal when using authentication.')
    }
    if $auth_secret == undef {
      fail('You must provide a secret when using authentication.')
    }
  }


  class { 'marathon::install': } ->
  class { 'marathon::service': }
}
