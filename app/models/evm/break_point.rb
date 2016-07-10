class Evm::BreakPoint < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :project

  def self.minimum_quantity_for_feature
    6
  end

  def self.create_minimum(project, last_date)
    min = Evm::BreakPoint.minimum_quantity_for_feature
    self.create_for_project(project, last_date, min)
  end

  def self.create_for_project(project, last_date, qtty)
    bps = qtty.times.map {|i| { project: project,
      day: last_date+((i*project.evm_frequency).days) } }
    Evm::BreakPoint.create!(bps)
  end

  def self.generate_until(project, date)
    bps = []
    last_date = project.created_on
    freq = project.evm_frequency.days
    until last_date > date
      bps <<  { project: project, day: last_date }
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
    create_minimum(project, Date.today)
  end
end
