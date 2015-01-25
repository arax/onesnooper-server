# Module housing available backend implementations for
# data stores. All stores must implement basic methods
# outlined in the `OnesnooperServer::Store` class.
module OnesnooperServer::Stores; end

# Load all available store types
Dir.glob(File.join(File.dirname(__FILE__), 'stores', "*.rb")) { |store_file| require store_file.chomp('.rb') }
