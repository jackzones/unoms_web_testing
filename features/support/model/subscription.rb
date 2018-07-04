class Subscription
  include Mongo::Document

  self.collection_name = 'subscription'
end
