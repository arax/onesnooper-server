require 'mongo'

#
#
#
class OnesnooperServer::Stores::MongodbStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    sleep(1)
  end

end
