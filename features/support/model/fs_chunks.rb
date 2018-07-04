class FsChunks
  include Mongo::Document

  self.collection_name = 'fs.chunks'
end
