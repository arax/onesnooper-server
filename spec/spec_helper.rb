require 'rubygems'

# enable coverage reports
if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.add_filter "/spec/"
  SimpleCov.start
end

require 'onesnooper-server'

Dir["#{File.dirname(__FILE__)}/helpers/*.rb"].each {|file| require file }
