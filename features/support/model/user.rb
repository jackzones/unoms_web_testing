class User
  include Mongo::Document

  self.collection_name = 'user'
end
