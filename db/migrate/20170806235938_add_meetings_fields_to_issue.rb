class AddMeetingsFieldsToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :metting_date, :date, null: true
    add_column :issues, :metting_start_time, :string, null: true
    add_column :issues, :metting_end_time, :string, null: true
  end

  def self.down
    remove_column :issues, :metting_date, :date
    remove_column :issues, :metting_start_time, :string
    remove_column :issues, :metting_end_time, :string
  end
end
