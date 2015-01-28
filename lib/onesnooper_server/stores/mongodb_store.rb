require 'mongo'

# MongoDB-based store for production deployments and dynamic
# document structure.
class OnesnooperServer::Stores::MongodbStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
  end

end
