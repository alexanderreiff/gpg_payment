$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'gpg_payment'
  s.version     = '0.2.2'
  s.date        = '2013-10-21'
  s.platform    = Gem::Platform::RUBY
  s.summary     = 'Gem to interface with GPG Merchant Processing API in a Ruby on Rails application'
  s.author      = 'Alexander Reiff'
  s.email       = 'alexander.reiff@me.com'
  s.files       = Dir['lib/*.rb'] + Dir['config/*.yml']
  
  s.add_dependency 'rails'
  s.add_dependency 'httparty'
end