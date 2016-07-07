class Evm::BreakPointsController < ApplicationController
  before_action :set_evm_break_point, only: [:show, :edit, :update, :destroy]
  before_action :set_project, only: [:index, :is_break_point_day]

  # GET /:project_id/evm/break_points
  def index
    @evm_break_points = Evm::BreakPoint.find_by(project: @project).all
  end


  def is_break_point_day
    tomorrow = Date.today + 1.days
    today = Date.today
    @evm_break_point = Evm::BreakPoint.where("date <= :tomorrow", tomorrow: tomorrow, project: @project).order(date: :asc).first
    if @evm_break_point.present? && ! @evm_break_point.calculated?
      if @evm_break_point.date == today
        @evm_break_point.calculate!
      else
      # please update your issues tomorrow will be the EVM BreakPoint
      end
    end
  end

  # GET /evm/break_points/1
  def show
  end

  # GET /evm/break_points/new
  def new
    @evm_break_point = Evm::BreakPoint.new
  end

  # GET /evm/break_points/1/edit
  def edit
  end

  # POST /evm/break_points
  def create
    @evm_break_point = Evm::BreakPoint.new(evm_break_point_params)

    if @evm_break_point.save
      redirect_to @evm_break_point, notice: 'Break point was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /evm/break_points/1
  def update
    if @evm_break_point.update(evm_break_point_params)
      redirect_to @evm_break_point, notice: 'Break point was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /evm/break_points/1
  def destroy
    @evm_break_point.destroy
    redirect_to evm_break_points_url, notice: 'Break point was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_evm_break_point
      @evm_break_point = Evm::BreakPoint.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def evm_break_point_params
      params.require(:evm_break_point).permit(:project_id, :planned_value, :actual_cost, :earned_value, :day)
    end

    def set_project
      @project = ::Project.find(params[:project_id])
    end
end
