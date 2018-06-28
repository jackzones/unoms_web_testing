class MongodbDatabase

  def initialize
    Mongo::Client.new('mongodb://127.0.0.1:27017/unoms')
  end

  # except_collection = ['license', 'script', 'permission', 'user', 'grid_state', 'settings']
  # client.collections.delete_if{|i| i.name == 'license'}.each {|i| i.delete_many}

  def delete_collection_data
    except_collection = ['license', 'script', 'permission', 'user', 'grid_state', 'settings']
    self.collections.delete_if{|i| except_collection.include?(i.name)}.each {|i| i.delete_many}
    self[:script].delete_many("built_in" => {"$ne" => true})
    self[:user].delete_many("username" => {"$ne" => "root"})
    self[:settings].update_one({"smtp_port" => 465}, "$set" => {"auto_mount" => false})
  end

end
