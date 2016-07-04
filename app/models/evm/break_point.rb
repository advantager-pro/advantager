class Evm::BreakPoint < ActiveRecord::Base
  belongs_to :project
  validate_presence_of :project

  def self.minimum_quantity_for_feature
    6
  end

  def self.create_minimum(project, last_date)
    min = EVM::BreakPoint.minimum_quantity_for_feature
    self.create_for_project(project, last_date, min)
  end

  def self.create_for_project(project, last_date, qtty)
    bps = qtty.times.map{ |i| { project: project, date: (i*project.evm_frequency).days+last_date } }
    Evm::BreakPoint.create!(bps)
  end

  def self.generate_until(project, date)
    bps = []
    last_date = project.created_at
    freq = project.evm_frequency.days
    until last_date > date
      bps <<  { project: project, date: last_date }
      last_date += freq
    end
    Evm::BreakPoint.create!(bps)
  end

  def calculated?
    self.earned_value.present?
  end

  def calculate!
    self.actual_cost = project.actual_cost
    self.earned_value = project.earned_value
    self.planned_value = project.planned_value
    self.save!
  end

  # The BreakPoint should be updated if it is a BreakPoint day
  after_update do
    create_minimum(project, date)
  end
end
