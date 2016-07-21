class EVM::Point < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project

  include EVM::Methods

  def self.update_current_point!(project)
    EVM::Point.find_or_initialize_by(project: project,
      day: Date.today).save!
  end

  # def self.grouped_by_day(project)
  #   tbname = self.table_name
  #   project.evm_points.select("#{tbname}.day, #{tbname}.project_id, SUM(#{tbname}.planned_value) as planned_value,
  #     SUM(#{tbname}.actual_cost) as actual_cost,
  #     SUM(#{tbname}.earned_value) as earned_value").group("#{tbname}.day, #{tbname}.project_id")
  # end

  def set_planned_value(date=nil)
    self.planned_value = self.project.planned_value(date)
  end

  def set_actual_cost(date=nil)
    # TODO: add date as param
    self.actual_cost = self.project.actual_cost
  end

  def set_earned_value(date=nil)
    # TODO: add date as param
    self.earned_value = self.project.earned_value
  end

  before_save do
    set_planned_value
    set_actual_cost
    set_earned_value
  end
end
