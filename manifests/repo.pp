# == Class marathon::repo
#
# This class manages apt/yum repository for Mesos packages
#

class marathon::repo {
  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      $distro = downcase($::operatingsystem)

      apt::source { 'mesosphere':
        location => "http://repos.mesosphere.io/${distro}",
        release  => $::lsbdistcodename,
        repos    => 'main',
        key      => {
          'id'     => '81026D0004C44CF7EF55ADF8DF7D54CBE56151BF',
          'server' => 'keyserver.ubuntu.com',
        },
        include  => {
          'src' => false
        },
      }
      include apt::update
    }
    'redhat': {
      $osrel = $::operatingsystemmajrelease
      case $osrel {
        '6': {
          $mrel = '2'
        }
        '7': {
          $mrel = '1'
        }
        default: {
          notify { "'${mrel}' is not supported for ${source}": }
        }
      }
      case $osrel {
        '6', '7': {
          package { 'mesosphere-el-repo':
            ensure   => present,
            provider => 'rpm',
            source   => "http://repos.mesosphere.io/el/${osrel}/noarch/RPMS/mesosphere-el-repo-${osrel}-${mrel}.noarch.rpm"
          }
        }
        default: {
          notify { "Yum repository '${source}' is not supported for major version ${::operatingsystemmajrelease}": }
        }
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
