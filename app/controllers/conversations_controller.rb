class ConversationsController < ApplicationController
  # before_filter :authenticate_user!

  layout false

  def create
    between = Conversation.between(params[:sender_id], params[:recipient_id])
    @conversation = ! between.empty? ? between.first : Conversation.create!(conversation_params)
    render json: { conversation_id: @conversation.id }
  end

  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = @conversation.messages.build
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

  def interlocutor(conversation)
    User.current == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
