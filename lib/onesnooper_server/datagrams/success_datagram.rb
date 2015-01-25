# Handles processing of datagrams with SUCESS monitoring
# messages. Performs 'save' operation on the backend.
class OnesnooperServer::Datagrams::SuccessDatagram < ::OnesnooperServer::Datagram

  def run(deferred_callback)
    ::EventMachine.defer do
      parse_payload!
      store_all!
      deferred_callback.succeed "Successful monitoring result was recorded in #{store_info.join(', ')}"
    end
  end

private

  # Decodes and parses datagram payload into a
  # hash-like structure. Modification is done
  # in-place.
  def parse_payload!
    # TODO: decode Base64 & parse ONE stuff
    # @params[:payload]
  end

  # Stores decoded and parsed payload in all
  # enabled data stores. Errors are logged
  # but not otherwise reported.
  def store_all!
    @params[:stores].each do |store|
      begin
        ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving data in #{store.class.name}"
        store.save!(DateTime.now, @params[:payload])
      rescue => ex
        ::OnesnooperServer::Log.error "[#{self.class.name}] Error while saving in #{store.class.name}: #{ex.message}"
      end
    end
  end

  # Returns human-readable information about enabled
  # backend stores.
  #
  # @return [Array] list of textual store information
  def store_info
    @params[:stores].collect { |store| store.class.name }
  end

end
