# NuoDB module for Puppet

[![Build Status](https://travis-ci.org/alfasystems/puppet-nuodb.svg?branch=master)](https://travis-ci.org/alfasystems/puppet-nuodb)
[![Puppet Forge](https://img.shields.io/puppetforge/v/alfasystems/nuodb.svg)](https://forge.puppetlabs.com/alfasystems/nuodb)

## Overview

Installs and configures NuoDB database.

## Requirements

* [Java 8 or higher](http://doc.nuodb.com/Latest/Content/System-Requirements.htm) - This module will by default use puppetlabs/java module to install Java it is requested not manage Java.
* Disable [Transparent Hugepages](http://doc.nuodb.com/Latest/Content/Note-About-%20Using-Transparent-Huge-Pages.htm) (THP) on Linux - This module will by default use alexharvey/disable_transparent_hugepage module to install Java it is requested not manage THP.

## Usage

### Installation using minimal parameters

This module can install and configure NuoDB with a minimal set of parameters.

It is highly rerecommendedhat you at least set your own ``domainPassword`` to make sure your database does not use the default password (``ch@ngeMe``) poprovidedy this module.

If you are not using Hiera, to setup NuoDB with the default parameters, just include the module.

```puppet
include ::nuodb
```

Or to set any parameters as follows.

```puppet
class { ::nuodb:
  config_overrides => {
    domainPassword => 'mySuperSecretPassword',
  },
}
```

#### With Hiera

All the configuration data required for this module can be prprovidedy Hiera, so just including the module should suffice in the in the Puppet code.

```puppet
include ::nuodb
```

In Hiera, it is rerecommendedo at least set the following.

```yaml
nuodb::config_overrides:
  domainPassword: 'mySuperSecretPassword'
```

### Installing on RedHat/CentOS 7

There is a [known issue](https://github.com/alexharv074/puppet-disable_transparent_hugepage#known-issues) in disabling THP on RedHat/CentOS unless the service_provider is specified when including the alexharv074/puppet-disable_transparent_hugepage module.

```puppet
class { ::disable_transparent_hugepage:
  service_provider => 'redhat',
}

class { ::nuodb:
  config_overrides => {
    domainPassword => 'mySuperSecretPassword',
  },
}
```

#### With Hiera

```puppet
include ::disable_transparent_hugepage:

include ::nuodb
```

```yaml
disable_transparent_hugepage::service_provider: redhat

nuodb::config_overrides:
  domainPassword: mySuperSecretPassword
```

### Install NuoDB without installing Java, if Java is already installed

```puppet
class { ::nuodb:
  manage_java => false,
}
```

#### With Hiera

```puppet
include ::nuodb
```

```yaml
nuodb::manage_java: false
```

### Setting properties in default.properties file

When using the ``config_overrides`` parameter, this will get merged with ``config_defaults`` to determine the final set of properties to set, where values defined in ``config_overrides`` will always win.

For example, to set the ``peer`` propoerty in the ``default.properties`` file in addition to all the defaults provided by the module,

```puppet
class { ::nuodb:
  config_overrides => {
    domainPassword => 'mySuperSecretPassword',
    peer           => '192.168.1.20',
  },
}
```

#### With Hiera

```puppet
include ::nuodb
```

```yaml
nuodb::config_overrides:
  domainPassword: mySuperSecretPassword
  peer: 192.168.1.20
```

### To not use any default values provided by this module for the default.properties file

To prevent using the provided default values for the default.properties file, redefine the ``config_defaults`` hash instead of using ``config_overrides``.

```puppet
class { ::nuodb:
  config_defaults => {
    domainPassword => 'superSecretDomainPassword',
  },
}
```

#### With Hiera

```puppet
include ::nuodb
```

```yaml
nuodb::config_defaults:
  domainPassword: superSecretDomainPassword
```

### Creating a domain administrator

```puppet
class { ::nuodb:
  domain_administrators => {
    'domainadmin1' => {
      ensure   => present,
      password => 'domainadmin1password,
    },
  },
}
```

#### With Hiera

```puppet
include ::nuodb
```

```yaml
nuodb::domain_administrators:
  domainadmin1:
    ensure: present
    password: domainadminpassword1
```

### Creating a database

```puppet
class { ::nuodb:
  databases => {
    'testdb1' => {
      ensure       => present,
      template     => 'Multi Host',
      dba_username => 'dba1',
      dba_password => 'secret1',
    },
  },
}
```

#### With Hiera

```puppet
include ::nuodb
```

```yaml
nuodb::databases:
  testdb1:
    ensure: present
    template: Multi Host
    dba_username: dba1
    dba_password: secret1
````

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

## nuodb::manager::database Parameters

* `ensure`
  The ensure value to determine if the database should be present or absent. Defaults to present.

* `nuodb_home`
  The directory where NuoDB is installed to. Defaults to the install location from the module.

* `broker_host`
  The host name for the broker instance to connect to create the database. Defaults to the `altAddr` property set for the default.properties in the module parameters.

* `domain_password`
  Domain password to use for authenticating with the broker. Defaults to the `domainPassword` property set for the default.properties in the module parameters.

* `database_name`
  Name of the database to create. Defaults to the title.

* `template`
  The database template to use, must be one of 'Single Host', 'Minimally Redundant', 'Multi Host' or 'Region distributed'. Defaults to 'Single Host'.

* `dba_username`
  Database administrator username for the database. Defaults to the title.

* `dba_password`
  Database administrator password for the database. Defaults to the title.

## nuodb::manager::domain_administrator Parameters

* `ensure`
  The ensure value to determine if the domain administrator should be present or absent. Defaults to present.

* `nuodb_home`
  The directory where NuoDB is installed to. Defaults to the install location from the module.

* `broker_host`
  The host name for the broker instance to connect to create the domain administrator. Defaults to the 'altAddr' property set for the default.properties in the module parameters.

* `domain_password`
  Domain password to use for authenticating with the broker. Defaults to the 'domainPassword' property set for the default.properties in the module parameters.

* `username`
  Domain administrator username for the domain. Defaults to the title.

* `password`
  Domain administrator password for the domain. Defaults to the title.

## Limitations

This module has only been tested on,

* RedHat/CentOS 7
* Ubuntu 16.04 (xenial)

## Development

Please feel free to raise feature requests, suggest improvements, report bugs and send pull requests.
