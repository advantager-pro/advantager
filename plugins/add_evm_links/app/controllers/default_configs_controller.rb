require 'rake'
require 'seed-fu'
RedmineApp::Application.load_tasks
class DefaultConfigsController < ApplicationController

  def show
  end

  def load
    Rake::Task['db:seed_fu'].execute
    flash[:success] = "Default configs loaded." # add to locales
  end
end
