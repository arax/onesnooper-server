class OnesnooperServer::Settings < ::Settingslogic
  gem_root = File.expand_path '../../..', __FILE__

  source "#{ENV['HOME']}/.onesnooper-server" if File.readable?("#{ENV['HOME']}/.onesnooper-server")
  source "/etc/onesnooper-server/onesnooper-server.yml" if File.readable?("/etc/onesnooper-server/onesnooper-server.yml")
  source "#{gem_root}/config/onesnooper-server.yml"

  namespace ENV['RAILS_ENV'] ? ENV['RAILS_ENV'] : 'production'
end
