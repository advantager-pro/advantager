class AddMeetingsFieldsToIssue < ActiveRecord::Migration
  def self.up
    add_column :issues, :meeting_date, :date, null: true
    add_column :issues, :meeting_start_time, :string, null: true
    add_column :issues, :meeting_end_time, :string, null: true
  end

  def self.down
    remove_column :issues, :meeting_date, :date
    remove_column :issues, :meeting_start_time, :string
    remove_column :issues, :meeting_end_time, :string
  end
end
