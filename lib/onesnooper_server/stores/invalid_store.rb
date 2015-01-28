# Placeholder store for invalid configuration handling and
# testing purposes.
class OnesnooperServer::Stores::InvalidStore < ::OnesnooperServer::Store

  def save!(timestamp, data)
    ::OnesnooperServer::Log.fatal "[#{self.class.name}] This is a dummy store, do not use it!"
    fail "InvalidStore selected as fallback, check your configuration!"
  end

end
