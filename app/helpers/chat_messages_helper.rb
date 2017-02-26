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

  def render_chat
    puts '', '', '',  User.current.logged?, '', '', ''
    return unless User.current.logged?
    javascript_tag("$.get('/conversations.js').done(function(data){
      console.log('conversation loaded')
    }).fail(function(){
      console.error('TODO: load message asking to reload or something')
    });")
  end
end
