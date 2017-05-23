class AddConstitutionalActToProject < ActiveRecord::Migration
  def up
    add_column :projects, :constitutional_act, :text
  end

  def down
    remove_column :projects, :constitutional_act, :text
  end
end
