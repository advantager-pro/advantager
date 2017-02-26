class ChangeDoneRatioFromIntegerToFloat < ActiveRecord::Migration
  def up
    change_column :issues, :done_ratio, :float
  end
  def down
    change_column :issues, :done_ratio, :integer
  end
end
