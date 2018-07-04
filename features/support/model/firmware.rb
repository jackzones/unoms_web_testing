class Firmware
  include Mongo::Document

  self.collection_name = 'firmware'
end
