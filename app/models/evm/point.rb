class Evm::Point < ActiveRecord::Base
  belongs_to :issue
  validates_presence_of :issue

  attr_accessible :project_id

  def project
    ::Project.find_by(id: project_id)
    # We cannot use issue.project because of the grouped_by_day
  end

  include EVM::Methods

  def self.update_current_point!(issue)
    Evm::Point.find_or_initialize_by(issue: issue,
      day: Date.today).save!
  end

  def self.grouped_by_day(project)
    tbname = self.table_name
    # extra_fields = self.column_names - %w( planned_value actual_cost earned_value )
    # extra_fields = extra_fields.map{ |c| "#{tbname}.#{c}" }.join(", ")
    # http://stackoverflow.com/questions/9068926/rails-3-group-by-and-sum
    project.evm_points.select("#{tbname}.day, #{::Issue.table_name}.project_id, SUM(#{tbname}.planned_value) as planned_value,
      SUM(#{tbname}.actual_cost) as actual_cost,
      SUM(#{tbname}.earned_value) as earned_value").group("#{tbname}.day, #{::Issue.table_name}.project_id")
  end

  before_save do
    self.planned_value = self.issue.planned_value
    self.actual_cost = self.issue.actual_cost
    self.earned_value = self.issue.earned_value
  end
end
