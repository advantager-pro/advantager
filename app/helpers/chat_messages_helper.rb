module ChatMessagesHelper
  def self_or_other(message)
    message.user == User.current ? "self" : "other"
  end

  def message_interlocutor(message)
    message.user == message.conversation.sender ? message.conversation.sender : message.conversation.recipient
  end

  def conversation_interlocutor(conversation)
    conversation.recipient == User.current ? conversation.sender : conversation.recipient
  end
end
