# Wrapper module for all available datagram processing
# classes. Each class has to implement method stubs
# outlined in `OnesnooperServer::Datagram`.
module OnesnooperServer::Datagrams; end

# Load all available datagram types
Dir.glob(File.join(File.dirname(__FILE__), 'datagrams', "*.rb")) { |datagram_file| require datagram_file.chomp('.rb') }
