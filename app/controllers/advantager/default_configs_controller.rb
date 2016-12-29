require 'rake'
require 'seed-fu'
RedmineApp::Application.load_tasks
class Advantager::DefaultConfigsController < ApplicationController

  def load
     Rake::Task['db:seed_fu'].execute
     flash[:success] = "Default configs loaded." # add to locales
  end
end
