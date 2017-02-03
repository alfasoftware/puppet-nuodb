# Class: nuodb::service
#
# This class manages NuoDB services.
#
class nuodb::service (
  $agent_service_ensure      = $::nuodb::agent_service_ensure,
  $agent_service_enable      = $::nuodb::agent_service_enable,
  $rest_service_ensure       = $::nuodb::rest_service_ensure,
  $rest_service_enable       = $::nuodb::rest_service_enable,
  $engine_service_ensure     = $::nuodb::engine_service_ensure,
  $engine_service_enable     = $::nuodb::engine_service_enable,
  $webconsole_service_ensure = $::nuodb::webconsole_service_ensure,
  $webconsole_service_enable = $::nuodb::webconsole_service_enable,
) inherits nuodb {

  service { 'nuoagent':
    ensure     => $agent_service_ensure,
    enable     => $agent_service_enable,
    hasstatus  => true,
    hasrestart => true,
  } ->

  service { 'nuorestsvc':
    ensure     => $rest_service_ensure,
    enable     => $rest_service_enable,
    hasstatus  => true,
    hasrestart => true,
  } ->

  service { 'nuoengine':
    ensure     => $engine_service_ensure,
    enable     => $engine_service_enable,
    hasstatus  => true,
    hasrestart => true,
  } ->

  service { 'nuowebconsole':
    ensure     => $webconsole_service_ensure,
    enable     => $webconsole_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
