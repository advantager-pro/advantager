class ChatBaseController < ApplicationController
  skip_before_filter  :session_expiration, :check_if_login_required, :check_password_change, :set_localization, :set_is_search_enabled
  layout false
end
