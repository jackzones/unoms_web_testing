class Log
  include Mongo::Document

  self.collection_name = 'log'
end
