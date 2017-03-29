class AddEarnedScheduleToPoints < ActiveRecord::Migration
  def change
    add_column :evm_points, :earned_schedule, :decimal
  end
end
