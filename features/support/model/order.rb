class Order
  include Mongo::Document

  self.collection_name = 'order'
end
