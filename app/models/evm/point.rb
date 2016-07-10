class Evm::Point < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project

  include EVM::Methods

  def self.update_current_point!(project)
    Evm::Point.find_or_initialize_by(project: project,
      day: Date.today).save!
  end

  # def self.grouped_by_day(project)
  #   tbname = self.table_name
  #   project.evm_points.select("#{tbname}.day, #{tbname}.project_id, SUM(#{tbname}.planned_value) as planned_value,
  #     SUM(#{tbname}.actual_cost) as actual_cost,
  #     SUM(#{tbname}.earned_value) as earned_value").group("#{tbname}.day, #{tbname}.project_id")
  # end

  before_save do
    self.planned_value = self.project.planned_value
    self.actual_cost = self.project.actual_cost
    self.earned_value = self.project.earned_value
  end
end
