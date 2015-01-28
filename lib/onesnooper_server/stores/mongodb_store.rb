require 'mongo'

# MongoDB-based store for production deployments and dynamic
# document structure.
class OnesnooperServer::Stores::MongodbStore < ::OnesnooperServer::Store

  # constant collection name
  MONGO_COLL_NAME = 'one_monitoring'

  def initialize(params = {})
    super
    @db_conn = ::Mongo::MongoClient.new(params[:host], params[:port])
    @db_active_db = @db_conn.db(params[:database])
    @db_coll = @db_active_db.create_collection(MONGO_COLL_NAME)
  end

  def save!(timestamp, data)
    ::OnesnooperServer::Log.debug "[#{self.class.name}] Saving #{timestamp.to_s} => #{data.inspect}"
    data['TIMESTAMP'] = timestamp.to_time.utc
    @db_coll.insert data
  end

end
