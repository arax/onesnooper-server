# Sqlite3-based store for testing and small deployments.
class OnesnooperServer::Stores::SqliteStore < ::OnesnooperServer::SqlStore

  def initialize(params = {})
    super
    @db_path = "sqlite://#{params[:database_file]}"
    @db_conn = ::Sequel.connect(@db_path)
  end

end
