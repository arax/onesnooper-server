require 'logger'

# Wrapper for log subscribers combining the functionality
# of `Logger` and `ActiveSupport::Notifications`. Allows
# the use of Singleton-like logging facilities.
class OnesnooperServer::Log

  include ::Logger::Severity

  attr_reader :logger, :log_prefix

  # Default subscription handle for notifications
  SUBSCRIPTION_HANDLE = "onesnooper-server.log"

  # Creates a new logger
  #
  # @param log_dev [IO,String] The log device.  This is a filename (String) or IO object (typically +STDOUT+, +STDERR+, or an open file).
  # @param log_prefix [String] String placed in front of every logged message
  def initialize(log_dev, log_prefix = '[onesnooper-server]')
    if log_dev.kind_of? ::Logger
      @logger = log_dev
    else
      @logger = ::Logger.new(log_dev)
    end

    @log_prefix = log_prefix.blank? ? '' : log_prefix.strip

    # subscribe to log messages and send to logger
    @log_subscriber = ActiveSupport::Notifications.subscribe(self.class::SUBSCRIPTION_HANDLE) do |name, start, finish, id, payload|
      @logger.log(payload[:level], "#{@log_prefix} #{payload[:message]}") if @logger
    end
  end

  def close
    ActiveSupport::Notifications.unsubscribe(@log_subscriber)
  end

  # @param severity [::Logger::Severity] severity
  def level=(severity)
    @logger.level = severity
  end

  # @return [::Logger::Severity]
  def level
    @logger.level
  end

  # @see info
  def self.debug(message)
    ActiveSupport::Notifications.instrument(self::SUBSCRIPTION_HANDLE, :level => ::Logger::DEBUG, :message => message)
  end

  # Log an +INFO+ message
  # @param message [String] message the message to log; does not need to be a String
  def self.info(message)
    ActiveSupport::Notifications.instrument(self::SUBSCRIPTION_HANDLE, :level => ::Logger::INFO, :message => message)
  end

  # @see info
  def self.warn(message)
    ActiveSupport::Notifications.instrument(self::SUBSCRIPTION_HANDLE, :level => ::Logger::WARN, :message => message)
  end

  # @see info
  def self.error(message)
    ActiveSupport::Notifications.instrument(self::SUBSCRIPTION_HANDLE, :level => ::Logger::ERROR, :message => message)
  end

  # @see info
  def self.fatal(message)
    ActiveSupport::Notifications.instrument(self::SUBSCRIPTION_HANDLE, :level => ::Logger::FATAL, :message => message)
  end

end
