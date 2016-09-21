# #Default roles
# #Project Manager - Director de proyecto
# man = Role.create(name: "Director", permissions: [:add_project, :edit_project, :close_project, :select_project_modules, :manage_members, :manage_versions,
#   :add_subprojects, :manage_boards, :add_messages, :edit_messages, :edit_own_messages, :delete_messages, :delete_own_messages, :view_calendar,
#    :add_documents, :edit_documents, :delete_documents, :view_documents, :manage_files, :view_files, :view_gantt, :manage_categories, :view_issues,
#    :add_issues, :edit_issues, :copy_issues, :manage_issue_relations, :manage_subtasks, :set_issues_private, :set_own_issues_private, :add_issue_notes,
#     :edit_issue_notes, :edit_own_issue_notes, :view_private_notes, :set_notes_private, :delete_issues, :manage_public_queries, :save_queries,
#      :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers, :import_issues, :manage_news, :comment_news, :manage_repository, :browse_repository,
#       :view_changesets, :commit_access, :manage_related_issues, :log_time, :view_time_entries, :edit_time_entries, :edit_own_time_entries,
#        :manage_project_activities, :manage_wiki, :rename_wiki_pages, :delete_wiki_pages, :view_wiki_pages, :export_wiki_pages, :view_wiki_edits,
#         :edit_wiki_pages, :delete_wiki_pages_attachments, :protect_wiki_pages],
#          issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)
#
# man.attributes = {name: "Manager", locale: :en}
# man.attributes = {name: "Director", locale: :es}
# man.save!
#
# #HHRR - RRHH
# hr = Role.create(name: "RRHH", permissions: [:manage_boards, :manage_subtasks, :add_messages,:manage_members, :comment_news, :view_wiki_pages,:edit_wiki_pages, :protect_wiki_pages,:edit_own_messages,
#   :delete_own_messages, :view_calendar, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,:add_issue_notes, :edit_own_issue_notes, :view_private_notes,:view_documents,
#   :manage_files, :view_files, :view_gantt, :edit_issues],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)
#
# hr.attributes = {name: "HHRR", locale: :en}
# hr.attributes = {name: "RRHH", locale: :es}
# hr.save!
#
# #Stakeholder - Interesado
# stk = Role.create(name: "Interesado",permissions: [:view_calendar,:comment_news, :view_issues],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: false)
#
# stk.attributes = {name: "Stakeholder", locale: :en}
# stk.attributes = {name: "Interesado", locale: :es}
# stk.save!
# #Supervisor - Supervisor
# sup = Role.create(name: "Supervisor", permissions: [:edit_issues,:manage_boards, :add_messages,:comment_news, :view_wiki_pages,:edit_wiki_pages, :protect_wiki_pages,:edit_own_messages,
#   :delete_own_messages, :view_calendar, :manage_subtasks, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,:view_documents,
#   :manage_files, :view_files, :view_gantt,:add_issue_notes, :edit_own_issue_notes, :view_private_notes],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)
#
# sup.attributes = {name: "Supervisor", locale: :en}
# sup.attributes = {name: "Supervisor", locale: :es}
# sup.save!
#
#
# #Worker - Realizador
# wk = Role.create(name: "Realizador", permissions: [:view_files,:view_calendar,:comment_news, :view_issues,:add_issues, :manage_issue_relations, :manage_subtasks,
#   :add_issue_notes, :edit_own_issue_notes],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: false)
#
# wk.attributes = {name: "Worker", locale: :en}
# wk.attributes = {name: "Realizador", locale: :es}
# wk.save!
#
# #Default priorities
# low = IssuePriority.create(name: "Baja", position:1, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "lowest")
# low.attributes = {name: "Low", locale: :en}
# low.attributes = {name: "Baja", locale: :es}
# low.save!
#
# nor = IssuePriority.create(name: "Normal", position:2, is_default: true, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "Default")
# nor.attributes = {name: "Normal", locale: :en}
# nor.attributes = {name: "Normal", locale: :es}
# nor.save!
#
# hi = IssuePriority.create(name: "Alta", position:3, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "high")
# hi.attributes = {name: "High", locale: :en}
# hi.attributes = {name: "Alta", locale: :es}
# hi.save!
#
# cri =IssuePriority.create(name: "Critica", position:4, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "highest")
# cri.attributes = {name: "Critical", locale: :en}
# cri.attributes = {name: "Crítica", locale: :es}
# cri.save!
#
# #Default TimeEntryActivity
# pl = TimeEntryActivity.create(name: "Planificacion", position: 1, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# pl.attributes = {name: "Planification", locale: :en}
# pl.attributes = {name: "Planificación", locale: :es}
# pl.save!
#
# dev = TimeEntryActivity.create(name: "Desarrollo", position: 2, is_default: true, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# dev.attributes = {name: "Development", locale: :en}
# dev.attributes = {name: "Desarrollo", locale: :es}
# dev.save!
#
# inv = TimeEntryActivity.create(name: "Investigacion", position: 3, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# inv.attributes = {name: "Investigation", locale: :en}
# inv.attributes = {name: "Investigación", locale: :es}
# inv.save!
#
# tst = TimeEntryActivity.create(name: "Pruebas", position: 4, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# tst.attributes = {name: "Testing", locale: :en}
# tst.attributes = {name: "Pruebas", locale: :es}
# tst.save!
#
# doc = TimeEntryActivity.create(name: "Documentacion", position: 5, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# doc.attributes = {name: "Documentation", locale: :en}
# doc.attributes = {name: "Documentación", locale: :es}
# doc.save!
#
# evl = TimeEntryActivity.create(name: "Evaluacion", position: 6, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
# evl.attributes = {name: "Evaluation", locale: :en}
# evl.attributes = {name: "Evaluación", locale: :es}
# evl.save!
#
# #Default Issue status
# default_issue_status = IssueStatus.create(name: "Nueva", is_closed: false, position: 1, default_done_ratio: nil)
# default_issue_status.attributes = {name: "New", locale: :en}
# default_issue_status.attributes = {name: "Nueva", locale: :es}
# default_issue_status.save!
#
# pro =IssueStatus.create(name: "En progreso", is_closed: false, position: 2, default_done_ratio: nil)
# pro.attributes = {name: "In progress", locale: :en}
# pro.attributes = {name: "En progreso", locale: :es}
# pro.save!
#
# clo = IssueStatus.create(name: "Cerrada", is_closed: true, position: 3, default_done_ratio: 100)
# clo.attributes = {name: "Closed", locale: :en}
# clo.attributes = {name: "Cerrada", locale: :es}
# clo.save!
#
# rej = IssueStatus.create(name: "Rechazada", is_closed: false, position: 4, default_done_ratio: nil)
# rej.attributes = {name: "Rejected", locale: :en}
# rej.attributes = {name: "Rechazada", locale: :es}
# rej.save!
#
# mt = Tracker.create(name: "Hito", position: 1, is_in_roadmap: true, default_status_id: default_issue_status.id)
# mt.attributes = {name: "Milestone", locale: :en}
# mt.attributes = {name: "Hito", locale: :es}
# mt.save!
#
# ts = Tracker.create(name: "Tarea", position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id)
# ts.attributes = {name: "Task", locale: :en}
# ts.attributes = {name: "Tarea", locale: :es}
# ts.save!

# tmp where queries for update existing data remove after running in production
ts = Tracker.where(name: "Task").first
mil = Tracker.where(name: "Milestone").first
man = Role.where(name: "Manager").first
clo = IssueStatus.where(name: "Closed").first
default_issue_status = IssueStatus.where(name: "New").first
pro = IssueStatus.where(name: "In progress").first
rej = IssueStatus.where(name: "Rejected").first
wk = Role.where(name: "Worker").first
hr = Role.where(name: "HHRR").first
sup = Role.where(name: "Supervisor").first
#WorkflowTransition.delete_all()
### remove after running in production


#WorkflowTransition
#manager attribution over task
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#closed
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#Rejected
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#manager attribution when task is asigned to him and when he is the author
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#closed
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#Rejected
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#worker
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#when worker is author
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when worker is assignee
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#supervisor
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)


#when supervisor is author
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when supervisor is assignee
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#hhrr
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: 0, new_status_id: pro.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)


#when supervisor is author
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: clo.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: rej.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when supervisor is assignee
#new
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: ts.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)


#for Milestone
#WorkflowTransition
#manager attribution over task
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#closed
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
#Rejected
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#manager attribution when task is asigned to him and when he is the author
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: man.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: man.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#closed
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
#Rejected
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: man.id, assignee: true, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#worker
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: wk.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#when worker is author
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: wk.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when worker is assignee
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: wk.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#supervisor
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: sup.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)


#when supervisor is author
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: sup.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when supervisor is assignee
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: sup.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#hhrr
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: 0, new_status_id: pro.id, role_id: hr.id, assignee: false, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)


#when supervisor is author
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#closed
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: clo.id, new_status_id: rej.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#Rejected
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: pro.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: rej.id, new_status_id: clo.id, role_id: hr.id, assignee: false, author: true, type: "WorkflowTransition", field_name: nil, rule: nil)

#when supervisor is assignee
#new
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: pro.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: default_issue_status.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)

#in progress
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: default_issue_status.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
WorkflowTransition.create( tracker_id: mil.id, old_status_id: pro.id, new_status_id: clo.id, role_id: hr.id, assignee: true, author: false, type: "WorkflowTransition", field_name: nil, rule: nil)
