require 'puppetlabs_spec_helper/module_spec_helper'

# /spec
base_dir = File.dirname(File.expand_path(__FILE__))

if ENV["SIMPLECOV"]
  require "simplecov"
  SimpleCov.start { add_filter "/spec/" }
elsif ENV["TRAVIS"] && RUBY_VERSION.to_f >= 1.9
  require "coveralls"
  Coveralls.wear! { add_filter "/spec/" }
end

RSpec.configure do |c|
  c.module_path     = File.join(base_dir, 'fixtures', 'modules')
  c.manifest_dir    = File.join(base_dir, 'fixtures', 'manifests')
  c.manifest        = File.join(base_dir, 'fixtures', 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')

  # Coverage generation
  c.after(:suite) do
    RSpec::Puppet::Coverage.report!
  end
end
