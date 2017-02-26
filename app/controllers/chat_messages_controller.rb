class ChatMessagesController < ChatBaseController
  
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = ChatMessage.new(message_params.merge({ user: User.current, conversation: @conversation }))
    @message.save!
    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:chat_message).permit(:body) || {}
  end
end
