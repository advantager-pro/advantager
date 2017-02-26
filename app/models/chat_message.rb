class ChatMessage < ActiveRecord::Base
  belongs_to :conversation
  belongs_to :user

  validates_presence_of :body, :conversation_id, :user_id

  def unread?
    read_at.nil?
  end

  def mark_as_read!
    self.update_attributes!(read_at: Time.now)
  end
end
