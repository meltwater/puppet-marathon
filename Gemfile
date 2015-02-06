source "https://rubygems.org"

group :test do
  gem "rake"
  gem "puppet", ENV['PUPPET_VERSION'] || '~> 3.7.0'
  # We use this to get around this issue https://github.com/rodjek/puppet-lint/issues/331
  # with puppet-lint not respecting ignore paths
  gem "puppet-lint", :git => 'https://github.com/rodjek/puppet-lint.git', :ref => '62dfab'
  gem "rspec-puppet", :git => 'https://github.com/rodjek/rspec-puppet.git'
  gem "puppetlabs_spec_helper"
  gem "metadata-json-lint"
end

group :development do
  gem "travis"
  gem "travis-lint"
  gem "guard-rake"
end
