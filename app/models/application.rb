class Application < ApplicationRecord
    has_many :chats, dependent: :destroy

    validates :name, uniqueness: true
end
