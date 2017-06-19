class Advantager::EVM::Point < ActiveRecord::Base
  belongs_to :project, class_name: ::Project.to_s, foreign_key: "project_id"
  validates_presence_of :project, :day

  include ::Advantager::EVM::Methods
  include ::Advantager::EarnedSchedule

  def self.update_current_point!(project)
    self.save_point!(project, Date.today)
  end

  # def self.grouped_by_day(project)
  #   tbname = self.table_name
  #   project.evm_points.select("#{tbname}.day, #{tbname}.project_id, SUM(#{tbname}.planned_value) as planned_value,
  #     SUM(#{tbname}.actual_cost) as actual_cost,
  #     SUM(#{tbname}.earned_value) as earned_value").group("#{tbname}.day, #{tbname}.project_id")
  # end

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

  def self.find_and_read(point, attr, date)
    if date.nil? || date == point.day
      point.read_attribute(attr) 
    else
      self.save_point!(p.project, date).send(attr, date)
    end
  end

  def planned_value(date=nil)
    self.class.find_and_read(self, :planned_value, date)
  end

  def earned_value(date=nil)
    self.class.find_and_read(self, :earned_value, date)
  end

  def actual_cost(date=nil)
    self.class.find_and_read(self, :actual_cost, date)
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
