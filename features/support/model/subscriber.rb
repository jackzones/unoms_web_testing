class Subscriber
  include Mongo::Document

  self.collection_name = 'subscriber'
end
