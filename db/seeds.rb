#Default roles
#Project Manager - Director de proyecto
Role.create(name: "Director", permissions: [:add_project, :edit_project, :close_project, :select_project_modules, :manage_members, :manage_versions,
  :add_subprojects, :manage_boards, :add_messages, :edit_messages, :edit_own_messages, :delete_messages, :delete_own_messages, :view_calendar,
   :add_documents, :edit_documents, :delete_documents, :view_documents, :manage_files, :view_files, :view_gantt, :manage_categories, :view_issues,
   :add_issues, :edit_issues, :copy_issues, :manage_issue_relations, :manage_subtasks, :set_issues_private, :set_own_issues_private, :add_issue_notes,
    :edit_issue_notes, :edit_own_issue_notes, :view_private_notes, :set_notes_private, :delete_issues, :manage_public_queries, :save_queries,
     :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers, :import_issues, :manage_news, :comment_news, :manage_repository, :browse_repository,
      :view_changesets, :commit_access, :manage_related_issues, :log_time, :view_time_entries, :edit_time_entries, :edit_own_time_entries,
       :manage_project_activities, :manage_wiki, :rename_wiki_pages, :delete_wiki_pages, :view_wiki_pages, :export_wiki_pages, :view_wiki_edits,
        :edit_wiki_pages, :delete_wiki_pages_attachments, :protect_wiki_pages],
         issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)

#HHRR - RRHH
Role.create(name: "RRHH", permissions: [:manage_boards, :manage_subtasks, :add_messages,:manage_members, :comment_news, :view_wiki_pages,:edit_wiki_pages, :protect_wiki_pages,:edit_own_messages,
  :delete_own_messages, :view_calendar, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,:add_issue_notes, :edit_own_issue_notes, :view_private_notes,:view_documents,
  :manage_files, :view_files, :view_gantt, :edit_issues],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)

#Stakeholder - Interesado
Role.create(name: "Interesado",permissions: [:view_calendar,:comment_news, :view_issues],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: false)

#Supervisor - Supervisor
Role.create(name: "Supervisor", permissions: [:edit_issues,:manage_boards, :add_messages,:comment_news, :view_wiki_pages,:edit_wiki_pages, :protect_wiki_pages,:edit_own_messages,
  :delete_own_messages, :view_calendar, :manage_subtasks, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,:view_documents,
  :manage_files, :view_files, :view_gantt,:add_issue_notes, :edit_own_issue_notes, :view_private_notes],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)

#Worker - Realizador
Role.create(name: "Realizador", permissions: [:view_files,:view_calendar,:comment_news, :view_issues,:add_issues, :edit_issues, :manage_issue_relations, :manage_subtasks,
  :add_issue_notes, :edit_own_issue_notes],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: false)

#Default priorities
IssuePriority.create(name: "Low", position:1, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "lowest")
IssuePriority.create(name: "Normal", position:2, is_default: true, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "Default")
IssuePriority.create(name: "Alta", position:3, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "high")
IssuePriority.create(name: "Critica", position:4, type: "IssuePriority", active: true, project_id: nil, parent_id: nil, position_name: "highest")

#Default TimeEntryActivity
TimeEntryActivity.create(name: "Planificacion", position: 1, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
TimeEntryActivity.create(name: "Desarrollo", position: 2, is_default: true, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
TimeEntryActivity.create(name: "Investigacion", position: 3, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
TimeEntryActivity.create(name: "Pruebas", position: 4, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
TimeEntryActivity.create(name: "Documentacion", position: 5, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)
TimeEntryActivity.create(name: "Evaluacion", position: 6, is_default: false, type: "TimeEntryActivity", active: true, project_id: nil, parent_id: nil, position_name: nil)

#Default Issue status
default_issue_status = IssueStatus.create(name: "Nueva", is_closed: false, position: 1, default_done_ratio: nil)
IssueStatus.create(name: "En progreso", is_closed: false, position: 2, default_done_ratio: nil)
IssueStatus.create(name: "En evaluacion", is_closed: false, position: 3, default_done_ratio: nil)
IssueStatus.create(name: "Cerrada", is_closed: true, position: 4, default_done_ratio: 100)
IssueStatus.create(name: "Rechazada", is_closed: false, position: 5, default_done_ratio: nil)

Tracker.create(name: "Hito", position: 1, is_in_roadmap: true, default_status_id: default_issue_status.id)
Tracker.create(name: "Tarea", position: 2, is_in_roadmap: true, default_status_id: default_issue_status.id)
