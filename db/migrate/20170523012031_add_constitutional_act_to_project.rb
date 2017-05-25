class AddConstitutionalActToProject < ActiveRecord::Migration
  def up
    add_attachment :projects, :constitutional_act
  end

  def down
    remove_attachment :projects, :constitutional_act
  end
end
