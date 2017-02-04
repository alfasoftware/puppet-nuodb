require 'spec_helper'

describe 'nuodb::config' do
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
    is_expected.to contain_class('nuodb')
    is_expected.to contain_class('nuodb::params')
    is_expected.to contain_class('nuodb::config')
    is_expected.to contain_file('/opt/nuodb/etc/default.properties')
      .with_ensure('present').with_owner('nuodb').with_group('nuodb').with_mode('0600')
      .with_content(
        "# Managed by Puppet. Do not make changes.\n\n" \
        "domain=domain\n" \
        "domainPassword=ch@ngeMe\n" \
        "broker=true\n" \
        "portRange=48005\n" \
        "singleHostDbRestart=true\n" \
        "advertiseAlt=true\n" \
        "altAddr=localhost\n"
      )
  end
end
