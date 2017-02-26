class ConversationsController < ChatBaseController

  before_filter :set_users, if: :user_logged_in, only: :index
  before_filter :set_conversation, only: [:show]

  def index
  end

  def create
    between = Conversation.between(params[:sender_id], params[:recipient_id])
    @conversation = ! between.empty? ? between.first : Conversation.create!(conversation_params)
    render json: { conversation_id: @conversation.id }
  end

  def show
    last_message = @conversation.messages.last
    last_message.mark_as_read! if last_message.present? && User.current.id != last_message.user.id
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages.last(15)
    @message = @conversation.messages.build
  end

  def unread
    render json: { unread: Conversation.unread(params[:user_id]).map(&:id) }
  end

  private
    def conversation_params
      params.permit(:sender_id, :recipient_id)
    end

    def interlocutor(conversation)
      User.current == conversation.recipient ? conversation.sender : conversation.recipient
    end

    def set_users
      @users = User.logged # I think this scope gives me the user list without the anonymous user
    end
    
    def user_logged_in
      User.current.logged?
    end

    def set_conversation
      @conversation = Conversation.find(params[:id])
    end
end
