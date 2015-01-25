#
#
#
class OnesnooperServer::Store
  #
  #
  #
  def initialize(params = {})
    @params = params
  end

  #
  #
  #
  def save(data)
    fail "This method needs to be implemented in subclasses"
  end
end
