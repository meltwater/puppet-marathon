# marathon

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
  package_ensure => '0.13.0',
  manage_repo    => true,
  install_java   => false,
  init_style     => 'systemd',
  bin_path       => '/usr/bin',
  extra_options  => '--event_subscriber http_callback',
  master         => 'zk://localhost:2181/mesos',
  zk             => 'zk://localhost:2181/marathon',
  manage_user    => true,
  user           => 'marathon',
  group          => 'marathon',
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

Determines the ensure state of the package.  Set to installed by default, but could
be changed to latest.

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

String, The URL of the Mesos master. The format is a comma-delimited list of
hosts like ``zk://host1:port,host2:port/mesos``. If using ZooKeeper, pay
particular attention to the leading ``zk://`` and trailing ``/mesos``!
If not using ZooKeeper, standard URLs like ``http://localhost`` are also acceptable.

#### `zk`

String, The ZooKeeper URL for storing state.

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
