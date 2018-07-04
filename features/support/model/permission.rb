class Permission
  include Mongo::Document

  self.collection_name = 'permission'
end
