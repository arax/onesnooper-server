require 'sequel'

#
#
#
class OnesnooperServer::Stores::SqliteStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
  end

end
