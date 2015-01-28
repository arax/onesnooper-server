# MySQL-based store for production deployments with static
# table structure.
class OnesnooperServer::Stores::MysqlStore < ::OnesnooperServer::SqlStore

  def initialize(params = {})
    super
    @db_conn = ::Sequel.connect(
      :adapter  => 'mysql2',
      :database => params[:database],
      :user     => params[:username],
      :password => params[:password],
      :host     => params[:host],
      :port     => params[:port],
    )
  end

end
