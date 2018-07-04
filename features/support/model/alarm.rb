class Alarm
  include Mongo::Document

  self.collection_name = 'alarm'
end
