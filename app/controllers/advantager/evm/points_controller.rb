class Advantager::EVM::PointsController < ApplicationController
  before_action :set_evm_point, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index]

  # GET /evm/points
  def index
    @evm_points = @project.evm_points#::Advantager::EVM::Point.grouped_by_day(@project)
    respond_to do |format|
      format.html
      format.json { render json: @evm_points }
    end
  end

  # GET /evm/points/1
  def show
  end

  # GET /evm/points/new
  def new
    @evm_point = Advantager::EVM::Point.new
  end

  # GET /evm/points/1/edit
  def edit
  end

  # POST /evm/points
  def create
    @evm_point = Advantager::EVM::Point.new(evm_point_params)

    if @evm_point.save
      redirect_to @evm_point, notice: 'Point was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /evm/points/1
  def update
    if @evm_point.update(evm_point_params)
      redirect_to @evm_point, notice: 'Point was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /evm/points/1
  def destroy
    @evm_point.destroy
    redirect_to evm_points_url, notice: 'Point was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evm_point
      @evm_point = Advantager::EVM::Point.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def evm_point_params
      params.require(:evm_point).permit(:issue_id, :planned_value, :actual_cost, :earned_value, :day)
    end

    def set_project
      @project = ::Project.find(params[:project_id])
    end

    def is_search_enabled
      false
    end
end
