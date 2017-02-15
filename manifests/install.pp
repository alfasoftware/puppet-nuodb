# Class: nuodb::install
#
# This class manages NuoDB package installation.
#
class nuodb::install (
  $package_ensure       = $::nuodb::package_ensure,
  $package_version      = $::nuodb::package_version,
  $package_provider     = $::nuodb::package_provider,
  $package_download_url = $::nuodb::package_download_url,
  $package_alt_name     = $::nuodb::package_alt_name,
  $package_alt_source   = $::nuodb::package_alt_source,
  $manage_wget          = $::nuodb::manage_wget,
) inherits nuodb {

  # Determine the package name
  $package_name = $package_alt_name ? {
    undef => $package_provider ? {
      /dpkg/  => "nuodb-ce_${package_version}_amd64.deb",
      /rpm/   => "nuodb-ce-${package_version}.x86_64.rpm",
      default => undef,
    },
    default => $package_alt_name,
  }

  # Determine the package source
  $package_source = $package_alt_source ? {
    undef => "/tmp/${package_name}",
    default => "${package_alt_source}/${package_name}",
  }

  # Download and install the package
  if ($package_alt_source == undef) {

    # Install wget
    if ($manage_wget) {
      package { 'wget':
        ensure => 'installed',
      }

      # wget should be installed for downloading nuodb installtion
      Package['wget'] -> Exec['download_nuodb']
    }

    exec { 'download_nuodb':
      command => "/usr/bin/wget -q -O /tmp/${package_name} ${package_download_url}/${package_name}",
      creates => "/tmp/${package_name}",
    }

    Exec['download_nuodb'] -> Package['nuodb']
  }

  package { 'nuodb':
    ensure   => $package_ensure,
    provider => $package_provider,
    source   => $package_source,
  }
}
