# -*- encoding : utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "sermepa_web_tpv/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "sermepa_web_tpv"
  s.version     = SermepaWebTpv::VERSION
  s.authors     = ["Ricard Forniol Agustí"]
  s.email       = ["ricard@forniol.cat"]
  s.homepage    = "http://github.com/ritxi/sermepa_web_tpv"
  s.summary     = "Add simple web tpv from sermepa to your rails application"
  s.description = "Simple rails engine to add payments to your web application using sermepa standard web tpv"

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency 'ruby-mcrypt'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "fuubar"
  s.add_development_dependency "nyan-cat-formatter"

end
