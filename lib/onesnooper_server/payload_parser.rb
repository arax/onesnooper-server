# Central parsing class for decoding and analyzing
# the content of incoming monitoring messages. Implements
# one publicly available method `parse(payload)`. Internally,
# the payload is decoded from Base64 and parsed into a
# hash-like structure.
class OnesnooperServer::PayloadParser

  TRIM_CLEANUP = /\s*/
  KEY          = /[[[:upper:]]|[[:digit:]]|_]+/
  VALUE        = /[[:alnum:]]+/
  QUOTED_VALUE = /.+/
  EQUALS       = /#{TRIM_CLEANUP}=#{TRIM_CLEANUP}/

  KEY_HASH_VALUE_REGEXP   = /#{TRIM_CLEANUP}^#{TRIM_CLEANUP}(?<key>#{KEY})#{EQUALS}\[#{TRIM_CLEANUP}(?<value>#{VALUE})#{TRIM_CLEANUP}\]#{TRIM_CLEANUP}/
  KEY_QUOTED_VALUE_REGEXP = /#{TRIM_CLEANUP}^#{TRIM_CLEANUP}(?<key>#{KEY})#{EQUALS}"(?<value>#{QUOTED_VALUE})"#{TRIM_CLEANUP}$#{TRIM_CLEANUP}/
  KEY_RAW_VALUE_REGEXP    = /#{TRIM_CLEANUP}^#{TRIM_CLEANUP}(?<key>#{KEY})#{EQUALS}(?<value>#{VALUE})#{TRIM_CLEANUP}$#{TRIM_CLEANUP}/

  # Parses given payload into a hash-like structure. Payload
  # is decoded from Base64 and then analyzed and parsed.
  #
  # @param payload [String] Base64-encoded payload with ONE monitoring data
  # @return [Hash] hash-like structure with parsed payload
  def self.parse(payload)
    return {} if payload.blank?
    analyze(decode(payload))
  end

private

  # Decodes given Base64-encoded string.
  #
  # @param payload [String] Base64-encoded string
  # @return [String] decoded string
  def self.decode(payload)
    ::OnesnooperServer::Log.debug "[#{self.name}] Decoding #{payload.inspect}"
    begin
      Base64.strict_decode64(payload)
    rescue => ex
      ::OnesnooperServer::Log.error "[#{self.name}] Decoding Base64 failed with: #{ex.message}"
      return ''
    end
  end

  # Analyzes payload content and returns a corresponding
  # hash-like structure.
  #
  # @param payload [String] plain text payload in ONE format
  # @return [Hash] a hash-like structure with analyzed payload content
  def self.analyze(payload)
    ::OnesnooperServer::Log.debug "[#{self.name}] Scanning decoded payload #{payload.inspect}"
    return {} if payload.blank?

    scanned_payload = {}
    scannable_payload = StringScanner.new(payload)
    begin
      if scanned = scannable_payload.scan(KEY_HASH_VALUE_REGEXP)
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
      elsif scanned = scannable_payload.scan(KEY_QUOTED_VALUE_REGEXP)
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
      elsif scanned = scannable_payload.scan(KEY_RAW_VALUE_REGEXP)
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
      else
        ::OnesnooperServer::Log.error "[#{self.name}] Failed scanning payload " \
                                      "#{payload.inspect} at #{scannable_payload.pos}"
        break
      end
    end until scannable_payload.eos?

    scanned_payload
  end

end
