class ChartsController < ::ApplicationController
  def evm_show
    @project = Project.find(params[:project_id])
  end
end