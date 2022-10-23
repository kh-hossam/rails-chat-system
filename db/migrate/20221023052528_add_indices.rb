class AddIndices < ActiveRecord::Migration[5.2]
  def change
    add_index :applications, :token
    add_index :chats, :number
    add_index :messages, :number
  end
end
