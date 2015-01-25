#
#
#
module OnesnooperServer::Stores; end

# Load all available store types
Dir.glob(File.join(File.dirname(__FILE__), 'stores', "*.rb")) { |store_file| require store_file.chomp('.rb') }
