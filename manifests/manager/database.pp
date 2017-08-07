# Define: nuodb::manager::database
#
# This type allows creating and deleting a database.
#
# @param ensure the ensure value to determine if the database should be present or absent. Defaults to present.
# @param nuodb_home the directory where NuoDB is installed to. Defaults to the install location from the module.
# @param broker_host the host name for the broker instance to connect to create the database. Defaults to the 'altAddr'
#   property set for the default.properties in the module parameters.
# @param domain_password domain password to use for authenticating with the broker. Defaults to the 'domainPassword'
#   property set for the default.properties in the module parameters.
# @param database_name name of the database to create. Defaults to the title.
# @param template the database template to use, must be one of 'Single Host', 'Minimally Redundant', 'Multi Host' or
#   'Region distributed'. Defaults to 'Single Host'.
# @param dba_username Database administrator username for the database. Defaults to the title.
# @param dba_password Database administrator password for the database. Defaults to the title.
#
# @example
#   class { '::nuodb' :
#     databases => {
#       'testdb1' => {
#         ensure       => present,
#         template     => 'Minimally Redundant',
#         dba_username => 'dba1',
#         dba_password => 'pwd1',
#       },
#     },
#   }
#
# @example
#   ::nuodb::manager::database { 'testdb1':
#     ensure       => present,
#     template     => 'Minimally Redundant',
#     dba_username => 'dba1',
#     dba_password => 'pwd1',
#   }
#
define nuodb::manager::database (
  $ensure          = 'present',
  $nuodb_home      = $::nuodb::nuodb_home,
  $broker_host     = $::nuodb::default_properties['altAddr'],
  $domain_password = $::nuodb::default_properties['domainPassword'],
  $database_name   = $title,
  $template        = 'Single Host',
  $dba_username    = 'dbaUser',
  $dba_password    = 'dbaPassword',
) {

  validate_re($ensure, '^(present|absent)$')
  validate_re($template, '^(Single Host|Minimally Redundant|Multi Host|Region distributed)$')

  $base_command = "${nuodb_home}/bin/nuodbmgr --broker '${broker_host}' --password '${domain_password}' --command"
  $exists_check = "${base_command} \"show domain databases\" | grep -q -e \"^${database_name} \\[\""

  if ($ensure == 'present') {
    $extra_params = "template '${template}' dbaUser '${dba_username}' dbaPassword '${dba_password}'"

    exec { "create-database-${database_name}" :
      command => "${base_command} \"create database dbname '${database_name}' ${extra_params}\"",
      unless  => $exists_check,
    }
  } else {
    exec { "shutdown-database-${database_name}" :
      command => "${base_command} \"shutdown database '${database_name}'\"",
      onlyif  => $exists_check,
    }
    -> exec { "delete-database-${database_name}" :
      command => "${base_command} \"delete database '${database_name}'\"",
      onlyif  => $exists_check,
    }
  }
}

