class ThingData
  include Mongo::Document

  self.collection_name = 'thing_data'
end
