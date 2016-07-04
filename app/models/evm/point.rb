class Evm::Point < ActiveRecord::Base
  belongs_to :issue
  validate_presence_of :issue

  def self.update_current_point!(issue)
    Evm::Point.find_or_initialize_by(issue: issue,
      date: Date.today).save!
  end

  def self.grouped_by_day(project)
    # http://stackoverflow.com/questions/9068926/rails-3-group-by-and-sum
    project.points.select("SUM(evm_points.planned_value) as planned_value,
      SUM(evm_points.actual_cost) as actual_cost
      SUM(evm_points.earned_value) as earned_value").group("evm_points.day")
  end

  before_save do
    self.planned_value = self.issue.planned_value
    self.actual_cost = self.issue.actual_cost
    self.earned_value = self.issue.earned_value
  end
end
