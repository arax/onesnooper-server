# Central parsing class for decoding and analyzing
# the content of incoming monitoring messages. Implements
# one publicly available method `parse(payload)`. Internally,
# the payload is decoded from Base64 and parsed into a
# hash-like structure.
class OnesnooperServer::PayloadParser

  TRIM_CLEANUP = /\s*/
  KEY          = /[[[:upper:]]|[[:digit:]]|_]+/
  VALUE        = /[[[:alnum:]]|_|-|\.|:]+/
  QUOTED_VALUE = /.+/
  HASH_VALUE   = /[^\]]+/
  EQUALS       = /#{TRIM_CLEANUP}=#{TRIM_CLEANUP}/

  KEY_HASH_VALUE_REGEXP   = /#{TRIM_CLEANUP}^#{TRIM_CLEANUP}(?<key>#{KEY})#{EQUALS}\[(?<value>#{HASH_VALUE})\]#{TRIM_CLEANUP}$#{TRIM_CLEANUP}/m
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
        scanned.strip!
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
      elsif scanned = scannable_payload.scan(KEY_QUOTED_VALUE_REGEXP)
        scanned.strip!
        scanned.gsub! "\n", ''
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
        analyze_simple(scanned, scanned_payload, KEY_QUOTED_VALUE_REGEXP)
      elsif scanned = scannable_payload.scan(KEY_RAW_VALUE_REGEXP)
        scanned.strip!
        scanned.gsub! "\n", ''
        ::OnesnooperServer::Log.debug "[#{self.name}] Scanned #{scanned.inspect}"
        analyze_simple(scanned, scanned_payload, KEY_RAW_VALUE_REGEXP)
      else
        ::OnesnooperServer::Log.error "[#{self.name}] Failed scanning payload " \
                                      "#{payload.inspect} at #{scannable_payload.pos}"
        break
      end
    end until scannable_payload.eos?

    scanned_payload
  end

  # Parses simple key value strings into the given
  # hash-like structure.
  #
  # @param key_value [String] input string
  # @param parsed [Hash] output hash-like structure
  # @return [Boolean] success or failure
  def self.analyze_simple(key_value, parsed, regexp)
    matched = key_value.match(regexp)
    if matched
      ::OnesnooperServer::Log.error "[#{self.name}] Matched #{key_value.inspect} " \
                                    "as #{matched[:key].inspect} and #{matched[:value].inspect}"
      parsed[matched[:key]] = typecast_if_num(matched[:value])
    else
      ::OnesnooperServer::Log.error "[#{self.name}] Couldn't match " \
                                    "#{key_value.inspect} as key & simple value"
    end

    true
  end

  # Attempts to type-cast values to `Integer` or `Float` if this casting
  # makes sense for the given value. Otherwise the original value
  # is returned.
  #
  # @param potential_num [String] value to type-cast if applicable
  # @return [String, Integer, Float] type-casted value if applicable
  def self.typecast_if_num(potential_num)
    case potential_num
    when potential_num.to_i.to_s
      potential_num.to_i
    when potential_num.to_f.to_s
      potential_num.to_f
    else
      potential_num
    end
  end

end
