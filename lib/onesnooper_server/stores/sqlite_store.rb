require 'sequel'

#
#
#
class OnesnooperServer::Stores::SqliteStore < ::OnesnooperServer::Store

  def initialize(params = {})
    super
    @db_path = "sqlite://#{params[:database_file]}"
    @db_conn = ::Sequel.connect(@db_path)
  end

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
  end

end
