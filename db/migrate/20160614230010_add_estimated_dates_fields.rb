class AddEstimatedDatesFields < ActiveRecord::Migration
  def self.up
    add_column :issues, :actual_due_date, :date
    add_column :issues, :actual_start_date, :date
  end

  def self.down
    remove_column :issues, :actual_due_date
    remove_column :issues, :actual_start_date
  end
end
