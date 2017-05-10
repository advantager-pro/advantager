require 'rake'
require 'seed-fu'
RedmineApp::Application.load_tasks
class DefaultConfigsController < ApplicationController

  def show
    @current_user = User.current
  end

  def load
    if check_current_user params[:username], params[:password]
      Rake::Task['db:seed_fu'].execute
      redirect_to default_configs_path
      flash[:success] = "Default configs loaded." # add to locales
    else
      redirect_to default_configs_path
      flash[:error] = "The credentials are wrong"
    end
  end

  private

  def check_current_user username, password
    current_user = User.current
    return current_user.login == username && current_user.check_password?(password)
  end

end
