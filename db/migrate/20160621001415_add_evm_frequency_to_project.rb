class AddEvmFrequencyToProject < ActiveRecord::Migration
  def change
    add_column :projects, :evm_frequency, :integer
  end
end
