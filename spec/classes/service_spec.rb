require 'spec_helper'

describe 'nuodb::service' do
  let :facts do
    {
      os: { family: 'Debian' },
      osfamily: 'Debian',
      operatingsystem: 'Ubuntu',
      architecture: 'x86_64',
      lsbdistcodename: 'xenial'
    }
  end

  it do
    is_expected.to contain_service('nuoagent')
      .with_ensure('running').with_enable(true).with_hasstatus(true).with_hasrestart(true)
    is_expected.to contain_service('nuorestsvc')
      .with_ensure('running').with_enable(true).with_hasstatus(true).with_hasrestart(true)
    is_expected.to contain_service('nuoengine')
      .with_ensure('stopped').with_enable(false).with_hasstatus(true).with_hasrestart(true)
    is_expected.to contain_service('nuowebconsole')
      .with_ensure('stopped').with_enable(false).with_hasstatus(true).with_hasrestart(true)
  end
end
