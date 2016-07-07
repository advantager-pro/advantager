class Evm::Point < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project

  include EVM::Methods

  def self.update_current_point!(project)
    Evm::Point.find_or_initialize_by(project: project,
      day: Date.today).save!
  end


  before_save do
    self.planned_value = self.project.planned_value
    self.actual_cost = self.project.actual_cost
    self.earned_value = self.project.earned_value
  end
end
