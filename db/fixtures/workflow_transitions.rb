#WorkflowTransition

ts = Tracker.where(name: I18n.t!("default_tracker_task")).first
mil = Tracker.where(name: I18n.t!("default_tracker_milestone")).first
man = Role.where(name: I18n.t!("default_role_manager")).first
clo = IssueStatus.where(name: I18n.t!("default_issue_status_closed")).first
default_issue_status = IssueStatus.where(name: I18n.t!("default_issue_status_new")).first
pro = IssueStatus.where(name: I18n.t!("default_issue_status_in_progress")).first
rej = IssueStatus.where(name: I18n.t!("default_issue_status_rejected")).first
wk = Role.where(name: I18n.t!("default_role_worker")).first
hr = Role.where(name: I18n.t!("default_role_hhrr")).first
sup = Role.where(name: I18n.t!("default_role_supervisor")).first
all_roles = Role.all
#WorkflowTransition.delete_all(}).first

#manager attribution over task
#new
WorkflowTransition.seed(:id,
  {id: 1, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 2, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 3, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 4, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 5, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#in progress
WorkflowTransition.seed(:id,
  {id: 6, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 7, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 8, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#closed
WorkflowTransition.seed(:id,
  {id: 9, tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 10, tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 11, tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#Rejected
WorkflowTransition.seed(:id,
  {id: 12, tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 13, tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 14, tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#manager attribution when task is asigned to him and when he is the author
#new
WorkflowTransition.seed(:id,
  {id: 15, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 16, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 17, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 18, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 19, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#in progress
WorkflowTransition.seed(:id,
  {id: 20, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 21, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 22, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#closed
WorkflowTransition.seed(:id,
  {id: 23, tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 24, tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 25, tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#Rejected
WorkflowTransition.seed(:id,
  {id: 26, tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 27, tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 1, tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#worker
#new
WorkflowTransition.seed(:id,
  {id: 28, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 29, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when worker is author
#new
WorkflowTransition.seed(:id,
  {id: 30, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 31, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 32, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 33, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 34, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 35, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 36, tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 37, tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 38, tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 39, tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 40, tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 41, tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when worker is assignee
#new
WorkflowTransition.seed(:id,
  {id: 42, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 43, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 44, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 45, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#supervisor
WorkflowTransition.seed(:id,
  {id: 46, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 47, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first


#when supervisor is author
#new
WorkflowTransition.seed(:id,
  {id: 48, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 49, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 50, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 51, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 52, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 53, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 54, tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 55, tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 56, tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 57, tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 58, tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 59, tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when supervisor is assignee
#new
WorkflowTransition.seed(:id,
  {id: 60, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 61, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 62, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 63, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#hhrr
WorkflowTransition.seed(:id,
  {id: 64, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 65, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first


#when supervisor is author
#new
WorkflowTransition.seed(:id,
  {id: 66, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 67, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 68, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 69, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 70, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 71, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 72, tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 73, tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 74, tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 75, tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 76, tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 77, tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when supervisor is assignee
#new
WorkflowTransition.seed(:id,
  {id: 78, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 79, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 80, tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 81, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first


#for Milestone
#WorkflowTransition
#manager attribution over task
#new
WorkflowTransition.seed(:id,
  {id: 82, tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 83, tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 84, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 85, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 86, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#in progress
WorkflowTransition.seed(:id,
  {id: 87, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 88, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 89, tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#closed
WorkflowTransition.seed(:id,
  {id: 90, tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 91, tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 92, tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#Rejected
WorkflowTransition.seed(:id,
  {id: 93, tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 94, tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 95, tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#manager attribution when task is asigned to him and when he is the author
#new
WorkflowTransition.seed(:id,
  {id: 96, tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 97, tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 98, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 99, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 100, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#in progress
WorkflowTransition.seed(:id,
  {id: 101, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 102, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 103, tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#closed
WorkflowTransition.seed(:id,
  {id: 104, tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 105, tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 106, tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
#Rejected
WorkflowTransition.seed(:id,
  {id: 107, tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 108, tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 109, tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#worker
#new
WorkflowTransition.seed(:id,
  {id: 110, tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 111, tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when worker is author
#new
WorkflowTransition.seed(:id,
  {id: 112, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 113, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 114, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 115, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 116, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 117, tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 118, tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 129, tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 120, tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 121, tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 122, tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 123, tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when worker is assignee
#new
WorkflowTransition.seed(:id,
  {id: 124, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 125, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 126, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 127, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#supervisor
WorkflowTransition.seed(:id,
  {id: 128, tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 129, tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first


#when supervisor is author
#new
WorkflowTransition.seed(:id,
  {id: 130, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 131, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 132, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 133, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 134, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 135, tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 136, tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 137, tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 138, tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 139, tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 140, tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 141, tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when supervisor is assignee
#new
WorkflowTransition.seed(:id,
  {id: 142, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 143, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 144, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 145, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#hhrr
WorkflowTransition.seed(:id,
  {id: 146, tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 147, tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first


#when supervisor is author
#new
WorkflowTransition.seed(:id,
  {id: 148, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 149, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 150, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 151, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 152, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 153, tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#closed
WorkflowTransition.seed(:id,
  {id: 154, tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 155, tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 156, tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#Rejected
WorkflowTransition.seed(:id,
  {id: 157, tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 158, tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 159, tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#when supervisor is assignee
#new
WorkflowTransition.seed(:id,
  {id: 160, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 161, tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#in progress
WorkflowTransition.seed(:id,
  {id: 162, tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
WorkflowTransition.seed(:id,
  {id: 163, tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

#meeting
#same permissions for all roles
next_id = 164
all_roles.each do |r|
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first
  next_id = next_id + 1
  WorkflowTransition.seed(:id,
    {id: next_id, tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: r.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil}).first

end