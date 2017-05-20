class ChartsController < ::ApplicationController
  def evm_show
    require_login
    @project = Project.find(params[:project_id])
  end
end