class CreateEvmBreakPoints < ActiveRecord::Migration
  def change
    create_table :evm_break_points do |t|
      t.references :project, index: true, foreign_key: true
      t.decimal :planned_value
      t.decimal :actual_cost
      t.decimal :earned_value
      t.date :day

      t.timestamps null: false
    end
  end
end
