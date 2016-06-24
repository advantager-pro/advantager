class CreateRoleTranslations < ActiveRecord::Migration
  def up
   Role.create_translation_table!(
    { :name => :string } ,
    { :migrate_data => true
    })
  end

 def down
   Role.drop_translation_table! :migrate_data => true
 end

end
