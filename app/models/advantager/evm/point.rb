class Advantager::EVM::Point < ActiveRecord::Base
  belongs_to :project, class_name: ::Project.to_s, foreign_key: "project_id"
  validates_presence_of :project, :day

  include ::Advantager::EVM::Methods
  include ::Advantager::EarnedSchedule

  def self.update_current_point!(project)
    self.save_point!(project, Date.today)
  end

  def self.by_day_range(start_date: , end_date:)
    where('day >= :start_date AND day <= :end_date', start_date: start_date, end_date: end_date)
  end

  def self.save_point!(project, date)
    p = ::Advantager::EVM::Point.find_or_initialize_by(project: project,
      day: date)
    p.save!
    p
  end

  def self.generate_from_project_begining(project, until_date=nil, from_date=nil)
    project.evm_points.destroy_all
    until_date = (until_date || ::Date.today).to_date
    last_date = (from_date || project.created_on).to_date
    until last_date > until_date
      self.save_point!(project, last_date)
      last_date += 1.day
    end
  end

  def set_planned_value(date=nil)
    self.planned_value = self.project.planned_value(date || self.day)
  end

  def set_actual_cost(date=nil)
    self.actual_cost = self.project.actual_cost(date || self.day)
  end

  def set_earned_value(date=nil)
    self.earned_value = self.project.earned_value(date || self.day)
  end

  before_save do
    set_planned_value
    set_actual_cost
    set_earned_value
  end
end
