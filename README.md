# NuoDB module for Puppet

[![Build Status](https://travis-ci.org/alfasystems/puppet-nuodb.svg?branch=master)](https://travis-ci.org/alfasystems/puppet-nuodb)
[![Puppet Forge](https://img.shields.io/puppetforge/v/alfasystems/nuodb.svg)](https://forge.puppetlabs.com/alfasystems/nuodb)

## Overview

Installs and configures NuoDB database.

## Requirements

* [Java 8 or higher](http://doc.nuodb.com/Latest/Content/System-Requirements.htm) - This module will by default use ``puppetlabs/java`` module to install Java it is requested not manage Java.
* Disable [Transparent Hugepages](http://doc.nuodb.com/Latest/Content/Note-About-%20Using-Transparent-Huge-Pages.htm) (THP) on Linux - This module will by default use ``alexharvey/disable_transparent_hugepage module`` to install Java it is requested not manage THP.

## Usage

### Installation using minimal parameters

This module can install and configure NuoDB with a minimal set of parameters.

It is highly recommened that you at least set your own ``domainPassword`` to make sure your database does not use the default password (``ch@ngeMe``) povided by this module.

#### Using Hiera

All the configuration data required for this module can be provied by Hiera, so just including the module should suffice in the in the Puppet code.

```puppet
include ::nuodb
```

In Hiera, it is recommened to at least set the following.

```yaml
nuodb::config_overrides:
  domainPassword: 'mySuperSecretPassword'
```

#### Without Hiera

If you are not using Hiera, to setup NuoDB with the default parameters, just include the module.

```puppet
include ::nuodb
```

Or to set any parameters,

```puppet
class { ::nuodb:
  config_overrides => {
    domainPassword => 'mySuperSecretPassword',
  },
}
```

### Install NuoDB without installing Java, if Java is already installed

```puppet
class { ::nuodb:
  config_overrides => {
    domainPassword => 'mySuperSecretPassword',
  },
  manage_java      => false,
}
```

### Setting properties in default.properties file

When using the ``config_overrides`` parameter, this will get merged with ``config_defaults`` to determine the final set of properties to set, where values defined in ``config_overrides`` will always win.

For example, to set the ``ipAddressOfExistingMachineToConnectTo`` propoerty in the ``default.properties`` file in addition to all the defaults provided by the module,

```puppet
class { ::nuodb:
  config_overrides => {
    domainPassword                        => 'mySuperSecretPassword',
    ipAddressOfExistingMachineToConnectTo => '192.168.1.20',
  },
}
```

### To not use any default values provided by this module for the default.properties file

To prevent using the provided default values for the default.properties file, redefine the ``config_defaults`` hash instead of using ``config_overrides``.

```puppet
class { ::nuodb:
  config_defaults => {
    domainPassword                        => 'mySuperSecretPassword',
    ipAddressOfExistingMachineToConnectTo => '192.168.1.20',
  },
}
```

## Module Parameters

* `manage_package`
  Boolean specifying whether or not to manage the package. Defaults to true.

* `package_ensure`
  The ensure value to be set for the package resource when installing the package. Defaults to installed.

* `package_version`
  Version of the package to install.

* `package_download_url`
  Location to download the package from.

* `package_alt_source`
  Alternative location to get the package from. Will disregard the package_download_url if this is set.

* `package_alt_name`
  Alternative package file name if the file names doesn't follow the standard distribution naming.

* `package_provider`
  Provider to use when installing the package. Defaults to rpm on RedHat OS family and dpkg on Debian OS family.

* `manage_java`
  Boolean specifying whether or not to manage install Java. Defaults to true.

* `manage_thp`
  Boolean specifying whether or not to manage Transparent Hugepages (THP). Defaults to true.

* `manage_wget`
  Boolean specifying whether or not to manage wget. Defaults to true.

* `config_overrides`
  Hash of properties to set in default.properties file, which will override any properties set via config_defaults parameter. It is recommended to set the domainPassword parameter either in overrides or defaults.

* `config_defaults`
  Hash of properties to set in default.properties by default unless overridden by config_overrides parameter. Uses sensible defaults. It is mandatory to set the domainPassword parameter either in overrides or defaults.

* `agent_service_ensure`
  The ensure value to set for the service resource for the agent service. Defaults to running.

* `agent_service_enable`
  Boolean enable parameter for the service resource to manage the agent service. Defaults to true.

* `rest_service_ensure`
  The ensure value to set for the service resource for the REST service. Defaults to running.

* `rest_service_enable`
  Boolean enable parameter for the service resource to manage the REST service. Defaults to true.

* `engine_service_ensure`
  The ensure value to set for the service resource for the engine service. Defaults to running.

* `engine_service_enable`
  Boolean enable parameter for the service resource to manage the engine service. Defaults to true.

* `webconsole_service_ensure`
  The ensure value to set for the service resource for the web console service. Defaults to running.

* `webconsole_service_enable`
  Boolean enable parameter for the service resource to manage the web console service. Defaults to true.

## Limitations

This module has only been tested on,

* RedHat/CentOS 7
* Ubuntu 16.04 (xenial)

## Development

To contribute, please feel free to raise feature requests, suggest improvements, report bugs and send pull requests.
