require 'spec_helper'

describe 'nuodb' do
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
    is_expected.to compile.with_all_deps

    is_expected.to contain_class('java')
      .that_comes_before('Package[nuodb]')
    is_expected.to contain_class('disable_transparent_hugepage')
      .that_comes_before('Service[nuoagent]')

    is_expected.to contain_class('nuodb')
    is_expected.to contain_anchor('::nuodb::begin').that_comes_before('Class[nuodb::install]')
    is_expected.to contain_class('nuodb::install').that_comes_before('Class[nuodb::config]')
    is_expected.to contain_class('nuodb::config').that_notifies('Class[nuodb::service]')
    is_expected.to contain_class('nuodb::service').that_comes_before('Anchor[::nuodb::end]')
    is_expected.to contain_anchor('::nuodb::end')
  end

  context 'without managing java' do
    let :params do
      {
        manage_java: false
      }
    end

    it do
      is_expected.not_to contain_class('java')
    end
  end

  context 'without managing thp' do
    let :params do
      {
        manage_thp: false
      }
    end

    it do
      is_expected.not_to contain_class('thp')
    end
  end
end
