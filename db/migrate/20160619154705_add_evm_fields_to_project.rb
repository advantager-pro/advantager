class AddEvmFieldsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :visible_fields, :string, array: true, default: []
    add_column :projects, :evm_field, :string
    add_column :projects, :currency, :string
    add_column :projects, :custom_unity, :string
  end
end
