#
#
#
class OnesnooperServer::UDPHandler < EM::Connection
  #
  #
  #
  def receive_data(command)
    command.chomp!
    log("Received #{command}")
    ::OnesnooperServer::RequestHandler.parse(command).run(callback)
  end

private
  #
  #
  #
  def callback
    ::EM::DefaultDeferrable.new.callback do |response|
      send_data(response + "\n")
      log(response)
    end
  end

  #
  #
  #
  def log(message)
    puts "#{DateTime.now.to_s} : #{message}"
  end
end
