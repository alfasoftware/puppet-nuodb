# frozen_string_literal: true

require 'spec_helper'

describe 'nuodb::manager::domain_administrator', type: :define do
  let :pre_condition do
    'class { "nuodb": }'
  end
  let :facts do
    {
      os: { family: 'Debian' },
      osfamily: 'Debian',
      operatingsystem: 'Ubuntu',
      architecture: 'x86_64',
      lsbdistcodename: 'xenial'
    }
  end
  let :title do
    'testadmin1'
  end

  it do
    is_expected.to compile.with_all_deps

    is_expected.to contain_exec('create-domain-administrator-testadmin1')
      .with_command('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
        '--command "create domain administrator user \'testadmin1\' password \'testadmin1\'"')
      .with_unless('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
        '--command "show domain administrators" | grep -q -Fx \'testadmin1\'')
  end

  context 'with different parameter values' do
    let :params do
      {
        broker_host: 'dbhost1',
        domain_password: 'asecret',
        username: 'usr',
        password: 'pwd'
      }
    end
    it do
      is_expected.to contain_exec('create-domain-administrator-usr')
        .with_command('/opt/nuodb/bin/nuodbmgr --broker \'dbhost1\' --password \'asecret\' ' \
          '--command "create domain administrator user \'usr\' password \'pwd\'"')
        .with_unless('/opt/nuodb/bin/nuodbmgr --broker \'dbhost1\' --password \'asecret\' ' \
          '--command "show domain administrators" | grep -q -Fx \'usr\'')
    end
  end

  context 'removing a domain administrator' do
    let :params do
      {
        ensure: 'absent'
      }
    end
    it do
      is_expected.to contain_exec('remove-domain-administrator-testadmin1')
        .with_command('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "remove domain administrator user \'testadmin1\'"')
        .with_onlyif('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "show domain administrators" | grep -q -Fx \'testadmin1\'')
    end
  end
end
