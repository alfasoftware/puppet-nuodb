require 'spec_helper'

describe 'nuodb::manager::database', type: :define do
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
    'testdb1'
  end

  it do
    is_expected.to compile.with_all_deps

    is_expected.to contain_exec('create-database-testdb1')
      .with_command('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
        '--command "create database dbname \'testdb1\' template \'Single Host\' ' \
        'dbaUser \'dbaUser\' dbaPassword \'dbaPassword\'"')
      .with_unless('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
        '--command "show domain databases" | grep -q -e "^testdb1 \\["')
  end

  context 'with different parameter values' do
    let :params do
      {
        broker_host: 'dbhost1',
        domain_password: 'asecret',
        database_name: 'testdb2',
        template: 'Region distributed',
        dba_username: 'dbausr',
        dba_password: 'dbapwd'
      }
    end
    it do
      is_expected.to contain_exec('create-database-testdb2')
        .with_command('/opt/nuodb/bin/nuodbmgr --broker \'dbhost1\' --password \'asecret\' ' \
          '--command "create database dbname \'testdb2\' template \'Region distributed\' ' \
          'dbaUser \'dbausr\' dbaPassword \'dbapwd\'"')
        .with_unless('/opt/nuodb/bin/nuodbmgr --broker \'dbhost1\' --password \'asecret\' ' \
          '--command "show domain databases" | grep -q -e "^testdb2 \\["')
    end
  end

  context 'removing a database' do
    let :params do
      {
        ensure: 'absent'
      }
    end
    it do
      is_expected.to contain_exec('shutdown-database-testdb1')
        .with_command('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "shutdown database \'testdb1\'"')
        .with_onlyif('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "show domain databases" | grep -q -e "^testdb1 \\["')

      is_expected.to contain_exec('delete-database-testdb1')
        .with_command('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "delete database \'testdb1\'"')
        .with_onlyif('/opt/nuodb/bin/nuodbmgr --broker \'localhost\' --password \'ch@ngeMe\' ' \
          '--command "show domain databases" | grep -q -e "^testdb1 \\["')
    end
  end
end
