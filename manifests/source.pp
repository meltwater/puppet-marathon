# == Class: marathon::source
#
class marathon::source (
  $version = undef,
  $download_url = undef,
  $download_extract_dir = undef,
  $install_dir = undef,
  $user = undef,
  $group = undef,
) {

  if $version {
    $version_real = $version
  } else {
    $version_real = '0.6.0'
  }

  $download_root_dir = "marathon-${version_real}"

  if $download_url {
    $download_url_real = $download_url
  } else {
    $download_url_real = "http://downloads.mesosphere.io/marathon/marathon-${version_real}/marathon-${version_real}.tgz"
  }

  archive { "marathon-${version_real}":
    url            => $download_url_real,
    target         => $download_extract_dir,
    root_dir       => $download_root_dir,
    checksum       => false,
    extension      => 'tgz',
    allow_insecure => true,
    timeout        => 1600,
  }

  exec { "marathon-${version_real} copy to install_dir":
    command => "cp -a ${download_extract_dir}/marathon-${version_real} ${install_dir}/marathon",
    creates => "${install_dir}",
    require => Archive["marathon-${version_real}"],
  }
  ->
  exec { "chown marathon install_dir":
    command     => "chown -R ${user}:${group} ${install_dir}",
    refreshonly => true,
  }

  file { "marathon-${version_real} service":
    ensure  => present,
    path    => "/etc/systemd/system/marathon.service",
    content => template("marathon/marathon.service.erb"),
    owner   => $user,
    group   => $group,
    require => Exec["chown marathon install_dir"],
  }
}
