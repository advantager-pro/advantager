#Default priorities
low = IssuePriority.seed(:id,
  {id: 1, name: I18n.t!("default_priority_low"), position:1, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "lowest"}).first

nor = IssuePriority.seed(:id,
  {id: 2, name: I18n.t!("default_priority_normal"), position:2, is_default: true, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "Default"}).first

hi = IssuePriority.seed(:id,
  {id: 3, name: I18n.t!("default_priority_high"), position:3, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "high"}).first

cri =IssuePriority.seed(:id,
  {id: 4, name: I18n.t!("default_priority_critical"), position:4, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "highest"}).first

priorities = {default_priority_high: hi, default_priority_low: low, default_priority_critical: cri, default_priority_normal: nor}
priorities.each do |translation, model|
  I18n.available_locales.each  do |loc|
    model.update_attributes(name: I18n.t!(translation, locale: loc), locale: loc)
  end
end
