require 'sequel'

#
#
#
class OnesnooperServer::Stores::SqliteStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    sleep(1)
  end

end
