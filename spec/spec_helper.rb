# Configure Rails Envinronment
ENV["RAILS_ENV"] = "test"


require File.expand_path("../dummy/config/environment.rb",  __FILE__)
#require "rails/test_help"
#require "rspec/rails"
require 'rspec/expectations'
require 'sermepa_web_tpv'
require 'pry-debugger'

#Rails.backtrace_cleaner.remove_silencers!

#migrate_path = File.expand_path("../dummy/db/migrate", __FILE__)
#seeds_path = File.expand_path("../dummy/db/seeds.rb", __FILE__)
#
#ActiveRecord::Migrator.migrate(migrate_path)
#if File.exists?(seeds_path)
#  load seeds_path
#end

RSpec.configure do |config|
  # Remove this line if you don't want RSpec's should and should_not
  # methods or matchers

  #config.use_transactional_fixtures = false

  config.include RSpec::Matchers



  # == Mock Framework
  config.mock_with :rspec
end