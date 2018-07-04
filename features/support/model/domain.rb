class Domain
  include Mongo::Document

  self.collection_name = 'domain'
end
