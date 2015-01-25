require 'sequel'

#
#
#
class OnesnooperServer::Stores::MysqlStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    sleep(1)
  end

end
