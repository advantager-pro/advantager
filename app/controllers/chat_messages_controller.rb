class ChatMessagesController < ApplicationController
  # before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge({ user_id: User.current.id }))
    @message.save!

    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:chat_message).permit(:body) || {}
  end
end
