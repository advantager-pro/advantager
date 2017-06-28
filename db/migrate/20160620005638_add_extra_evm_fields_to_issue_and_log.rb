class AddExtraEVMFieldsToIssueAndLog < ActiveRecord::Migration
  def up
    # point:float cost:decimal custom:decimal
    # estimated_hours
    add_column :issues, :estimated_point, :float
    add_column :issues, :estimated_cost, :decimal
    add_column :issues, :estimated_custom, :decimal
    change_column :issues, :estimated_hours, :float, null: true

    # hours
    add_column :time_entries, :actual_point, :float
    add_column :time_entries, :actual_cost, :decimal
    add_column :time_entries, :actual_custom, :decimal
    change_column :time_entries, :hours, :float, null: true

  end

  def down
    remove_column :issues, :estimated_point, :float
    remove_column :issues, :estimated_cost, :decimal
    remove_column :issues, :estimated_custom, :decimal
    remove_column :time_entries, :actual_point, :float
    remove_column :time_entries, :actual_cost, :decimal
    remove_column :time_entries, :actual_custom, :decimal
  end
end
