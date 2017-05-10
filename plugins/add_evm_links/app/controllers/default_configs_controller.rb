require 'rake'
require 'seed-fu'
RedmineApp::Application.load_tasks
class DefaultConfigsController < ApplicationController

  def show
    require_login
    @current_user = User.current
  end

  def load
    if check_current_user params[:username], params[:password]
      Rake::Task['db:seed_fu'].execute
      redirect_to default_configs_path
      flash[:notice] = l(:default_configs_succes) # add to locales
    else
      redirect_to default_configs_path
      flash[:error] = l(:notice_account_invalid_credentials)
    end
  end

  private

  def check_current_user username, password
    current_user = User.current
    return current_user.login == username && current_user.check_password?(password)
  end

end
