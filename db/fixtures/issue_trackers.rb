
default_issue_status = IssueStatus.where(name: I18n.t!("default_issue_status_new")).first

mt = Tracker.seed(:id,
  { id: 1, name: I18n.t!("default_tracker_milestone"), position: 1, is_in_roadmap: true, default_status_id: default_issue_status.id }).first

ts = Tracker.seed(:id,
  { id: 2, name: I18n.t!("default_tracker_task"), position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id }).first

meet = Tracker.seed(:id,
  { id: 3, name: I18n.t!("default_tracker_meeting"), position: 3, is_in_roadmap: true, default_status_id: default_issue_status.id }).first

trackers = { default_tracker_task: ts, default_tracker_milestone: mt, default_tracker_meeting: meet }
trackers.each do |translation, model|
  I18n.available_locales.each  do |loc|
    model.update_attributes(name: I18n.t!(translation, locale: loc), locale: loc)
  end
end
