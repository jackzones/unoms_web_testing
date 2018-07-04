class ChatMessage
  include Mongo::Document

  self.collection_name = 'chat_message'
end
