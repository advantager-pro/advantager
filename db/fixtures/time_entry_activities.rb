#Default TimeEntryActivity
pl = TimeEntryActivity.seed(:id,
  {id: nil ,name: I18n.t!("default_activity_planification"), position: 1, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

dev = TimeEntryActivity.seed(:id,
  {id: nil,name: I18n.t!("default_activity_development"), position: 2, is_default: true, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

inv = TimeEntryActivity.seed(:id,
  {id: nil,name: I18n.t!("default_activity_investigation"), position: 3, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

tst = TimeEntryActivity.seed(:id,
  {id: nil,name: I18n.t!("default_activity_testing"), position: 4, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

doc = TimeEntryActivity.seed(:id,
  {id: nil,name: I18n.t!("default_activity_documentation"), position: 5, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

evl = TimeEntryActivity.seed(:id,
  {id: nil,name: I18n.t!("default_activity_evaluation"), position: 6, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil}).first

activities = {default_activity_development: dev, default_activity_documentation: doc, default_activity_planification: pl,
    default_activity_evaluation: evl, default_activity_investigation: inv, default_activity_testing: tst}
activities.each do |translation, model|
  I18n.available_locales.each  do |loc|
    model.update_attributes(name: I18n.t!(translation, locale: loc), locale: loc)
  end
end
