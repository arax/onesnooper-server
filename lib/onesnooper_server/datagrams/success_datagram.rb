# Handles processing of datagrams with SUCESS monitoring
# messages. Performs 'save' operation on the backend.
class OnesnooperServer::Datagrams::SuccessDatagram < ::OnesnooperServer::Datagram

  def run(deferred_callback)
    ::EventMachine.defer do
      if parse_payload! && store_all!
        deferred_callback.succeed "Successful monitoring result was " \
                                  "recorded in #{store_info.join(', ')}"
      else
        deferred_callback.fail "Processing partially or completely failed, see logs"
      end
    end
  end

private

  # Decodes and parses datagram payload into a
  # hash-like structure. Modification is done
  # in-place.
  def parse_payload!
    @params[:payload] = ::OnesnooperServer::PayloadParser.parse(@params[:payload])
  end

  # Stores decoded and parsed payload in all
  # enabled data stores. Errors are logged
  # but not otherwise reported.
  #
  # @return [Boolean] success in all stores
  def store_all!
    if @params[:payload].blank?
      ::OnesnooperServer::Log.warn "[#{self.class.name}] Skipping empty payload " \
                                   "from ONE ID:#{@params[:host_id]}"
      return false
    end

    all_good = true
    @params[:stores].each do |store|
      begin
        ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving data in #{store.class.name}"
        store.save!(DateTime.now, @params[:payload])
      rescue => ex
        ::OnesnooperServer::Log.error "[#{self.class.name}] Error while saving " \
                                      "in #{store.class.name}: #{ex.message}"
        all_good = false
      end
    end

    all_good
  end

  # Returns human-readable information about enabled
  # backend stores.
  #
  # @return [Array] list of textual store information
  def store_info
    @params[:stores].collect { |store| store.class.name }
  end

end
