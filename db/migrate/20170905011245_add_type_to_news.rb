class AddTypeToNews < ActiveRecord::Migration
  def up
    add_column :news, :kind, :string, null: false, default: 'news'
  end
  def down
    remove_column :news, :kind, :string
  end
end
