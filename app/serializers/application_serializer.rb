class ApplicationSerializer < ActiveModel::Serializer
  attributes :token, :name, :chats_count
end
