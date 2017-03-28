class AddReadAtToChatMessages < ActiveRecord::Migration
  def change
    add_column :chat_messages, :read_at, :timestamp
  end
end
