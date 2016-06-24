class CreateTrackerTranslations < ActiveRecord::Migration
  def up
   Tracker.create_translation_table!(
    { :name => :string } ,
    { :migrate_data => true
    })
  end

 def down
   Tracker.drop_translation_table! :migrate_data => true
 end
end
