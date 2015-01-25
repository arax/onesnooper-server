#
#
#
class OnesnooperServer::Stores::InvalidStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    fail "InvalidStore is a dummy replacement. Check your configuration!"
  end

end
