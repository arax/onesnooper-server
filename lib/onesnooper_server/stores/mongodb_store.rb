require 'mongo'

#
#
#
class OnesnooperServer::Stores::MongodbStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
  end

end
