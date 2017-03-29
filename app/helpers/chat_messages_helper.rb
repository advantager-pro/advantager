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
    return unless User.current.logged?
    javascript_tag("$.get('/conversations.js').done(function(data){
      console.log('conversation loaded')
    }).fail(function(){
      displayFlash('#{I18n.t!('chat_load_error')}', 'error');
    });")
  end

  def turbolinks_escaped_subscribe_to(channel)
    subscription = PrivatePub.subscription(channel: channel)
    content_tag "script", :type => "text/javascript" do
      raw("var subscription = #{subscription.to_json};
      if(typeof window.LOCAL_SUBSCRIPTIONS === 'undefined') window.LOCAL_SUBSCRIPTIONS = {};
      if(typeof window.LOCAL_SUBSCRIPTIONS[subscription.channel] === 'undefined'){
        window.LOCAL_SUBSCRIPTIONS[subscription.channel] = true;
        PrivatePub.sign(subscription);
      }")
    end

  end

  def avatar_image user=nil
    user ||= @user
    gravatar_image_tag(user.try(:mail) || "#{user.try(:name)}#{user.try(:id)}", :alt => user.try(:name), size: 40,gravatar: { default: :identicon })
  end    
end
