class ConversationsController < ChatBaseController

  before_filter :set_users, :set_conversations, if: :user_logged_in, only: :index

  def index
  end

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

    def set_users
      @users = User.logged # I think this scope gives me the user list without the anonymous user
    end

    def set_conversations
      @conversations = Conversation.involving(User.current).order("created_at DESC")
    end

    def user_logged_in
      User.current.logged?
    end
end
