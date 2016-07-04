class CreateEvmPoints < ActiveRecord::Migration
  def change
    create_table :evm_points do |t|
      t.references :issue, index: true, foreign_key: true
      t.decimal :planned_value
      t.decimal :actual_cost
      t.decimal :earned_value
      t.date :day, index: true

      t.timestamps null: false
    end
  end
end
