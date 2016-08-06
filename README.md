# marathon
[![Puppet Forge Version](http://img.shields.io/puppetforge/v/meltwater/marathon.svg)](https://forge.puppetlabs.com/meltwater/marathon)
[![Puppet Forge Downloads](http://img.shields.io/puppetforge/dt/meltwater/marathon.svg)](https://forge.puppetlabs.com/meltwater/marathon)
[![Travis branch](https://img.shields.io/travis/meltwater/puppet-marathon/master.svg)](https://travis-ci.org/meltwater/puppet-marathon)
[![By Meltwater](https://img.shields.io/badge/by-meltwater-28bbbb.svg)](http://underthehood.meltwater.com/)
[![Maintenance](https://img.shields.io/maintenance/yes/2016.svg)](https://github.com/meltwater/puppet-marathon/commits/master)
[![license](https://img.shields.io/github/license/meltwater/puppet-marathon.svg)](https://github.com/meltwater/puppet-marathon/blob/master/LICENSE)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with marathon](#setup)
    * [What marathon affects](#what-marathon-affects)
    * [Beginning with marathon](#beginning-with-marathon)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
   * [RedHat module dependencies](#redhat-module-dependecies)

## Overview

Provides a class to install the [Marathon](https://mesosphere.github.io/marathon/) framework for [Mesos](http://mesos.apache.org/).

## Module Description
The marathon module sets up marathon on a mesos cluster.

This module has been tested against Marathon 0.13.0 and Mesos 0.26.0 and is known to not support
all features against earlier versions.

## Setup

### What marathon affects

* marathon repository files.
* marathon package.
* marathon configuration file.
* marathon service.

### Beginning with marathon


```puppet
include '::marathon'
```

## Usage

All options and configuration can be done through interacting with the parameters
on the main marathon class.  These are documented below.

## marathon class

To begin with the marathon class controls the installation of marathon.  In here
you can control many parameters relating to the package and service, such as
disabling puppet support of the service:

```puppet
class { '::marathon':
  package_ensure  => 'present',
  version         => '0.15.2',
  manage_repo     => true,
  install_java    => false,
  init_style      => 'systemd',
  bin_path        => '/usr/bin',
  extra_options   => '--event_subscriber http_callback',
  master          => ['localhost'], # or ['localhost:2181']
  master_url_type => 'zookeeper', # default
  master_zk_path  => 'mesos', # default
  zk              => ['localhost'],
  zk_path         => 'marathon', # default
  zk_default_port => '2181', # default
  manage_user     => true,
  user            => 'marathon',
  group           => 'marathon',
}

```

Or automatically installing java as part of the marathon setup:

```puppet
class { '::marathon':
  ...
  install_java => true,
  java_version => 'java-1.7.0-openjdk',
}
```

## Reference

## Classes

* marathon: Main class for installation and service management.
* marathon::install: Handles package installation.
* marathon::params: Different configuration data for different systems.
* marathon::service: Handles the marathon service.
* marathon::repo: Handles apt repo for Redhat/Debian systems.

### Parameters

#### `package`

String, the name of the package to install.

#### `package_ensure`

Determines the ensure state of the package.  Set to present by default, but could
be changed to latest.

#### `version`

Determines the version of the package.  Set to undef by default, but could
be changed to 0.15.2, etc...

#### `manage_repo`

Boolean, whether or not to manage package repositories for mesosphere.

#### `install_java`

Boolean, if enabled install the java JDK

#### `java_version`

String, the java version to install.

#### `init_style`

String, the style of init system your system uses.

#### `bin_path`

String, the path of the marathon executable.

#### `service_enable`

Boolean, if enabled enables the marathon service.

#### `service_ensure`

The state of the service..

#### `extra_options`

String, the extra options on the marathon command

#### `master`

Array, An array of Mesos master URLs.
If using zookeeper, the format is ``['host1', 'host2']`` or
``['host1:2181', 'host2:2181']``. That will internally
be converted to a zk url like ``zk://host1:port,host2:port/mesos`` by using
``master_zk_path``(default: mesos) and ``zk_default_port``(default: 2181)
If not using ZooKeeper, a format like ``['http://host1', 'http://host2']``
is also acceptable with ``master_url_type`` set to "http"

#### `zk`

Array, The ZooKeeper Hosts for storing state.
An array of ZooKeeper IPs.
The format is ``['host1', 'host2']`` or
``['host1:2181', 'host2:2181']``. That will internally be converted
to a zk url like ``zk://host1:port,host2:port/marathon`` by using
``zk_path``(default: marathon) and ``zk_default_port``(default: 2181)

#### `master_url_type`

String, the type of the master endpoints, 'zookeeper' or 'http'

#### `master_zk_path`

String, the trailing path to use for the ``master`` endpoints.

#### `zk_path`

String, the trailing path to use for the ``zk`` endpoints.

#### `zk_default_port`

String, the default port to use for zookeeper urls.

#### `manage_user`

Boolean, if enabled sets up the user that the marathon process will run as .

#### `user`

String, the user name to use if ``manage_user = true``.

#### `group`

String, the user group to use if ``manage_user = true``.


## Limitations

This module has been built on and tested against Puppet 3.x and Puppet 4.x

The module has been tested on:

* RedHat Enterprise Linux 6/7
* Debian 6/7
* CentOS 6/7
* Ubuntu 12.04/14.04

Testing on other platforms has been light and cannot be guaranteed.

### Module dependencies

If running CentOS/RHEL, and using the yum provider, ensure the ``epel`` repo is present.

If you want to run Marathon, you'll likely want to look at this module too ``https://forge.puppetlabs.com/deric/mesos``
