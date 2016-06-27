class CreateIssueTreeTranslations < ActiveRecord::Migration
  def up
   IssueStatus.create_translation_table!(
    { :name => :string } ,
    { :migrate_data => true
    })
   IssuePriority.create_translation_table!(
    { :name => :string } ,
    { :migrate_data => true
    })
  end

 def down
   IssueStatus.drop_translation_table! :migrate_data => true
   IssuePriority.drop_translation_table! :migrate_data => true
 end
end
