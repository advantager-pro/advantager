#Default roles
#Project Manager - Director de proyecto
man = Role.seed(:id,
  { id: 2, name: "Director", permissions: [:add_project, :edit_project, :close_project, :select_project_modules, :manage_members, :manage_versions,
    :add_subprojects, :manage_boards, :add_messages, :edit_messages, :edit_own_messages, :delete_messages, :delete_own_messages, :view_calendar,
     :add_documents, :edit_documents, :delete_documents, :view_documents, :manage_files, :view_files, :view_gantt, :manage_categories, :view_issues,
     :add_issues, :edit_issues, :copy_issues, :manage_issue_relations, :manage_subtasks, :set_issues_private, :set_own_issues_private, :add_issue_notes,
      :edit_issue_notes, :edit_own_issue_notes, :view_private_notes, :set_notes_private, :delete_issues, :manage_public_queries, :save_queries,
       :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers, :import_issues, :manage_news, :comment_news, :manage_repository,
       :browse_repository,:view_changesets, :commit_access, :manage_related_issues, :log_time, :view_time_entries, :edit_time_entries,
       :edit_own_time_entries, :manage_project_activities, :manage_wiki, :rename_wiki_pages, :delete_wiki_pages, :view_wiki_pages, :export_wiki_pages,
        :view_wiki_edits, :edit_wiki_pages, :delete_wiki_pages_attachments, :protect_wiki_pages],
           issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true }).first

#HHRR - RRHH
hr =  Role.seed(:id,
  { id: 3, name: "RRHH", permissions: [:manage_boards, :manage_subtasks, :add_messages,:manage_members, :comment_news, :view_wiki_pages,:edit_wiki_pages,
     :protect_wiki_pages,:edit_own_messages, :delete_own_messages, :view_calendar, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,
      :add_issue_notes, :edit_own_issue_notes, :view_private_notes,:view_documents, :manage_files, :view_files, :view_gantt, :edit_issues],
        issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true }).first

#Stakeholder - Interesado
stk = Role.seed(:id,
  { id: 4,name: "Interesado",permissions: [:view_calendar,:comment_news, :view_issues],issues_visibility: "all", users_visibility: "all",
     time_entries_visibility: "all", all_roles_managed: false}).first

#  Supervisor - Supervisor
sup = Role.seed(:id,
  { id: 5, name: "Supervisor", permissions: [:edit_issues,:manage_boards, :add_messages,:comment_news, :view_wiki_pages,:edit_wiki_pages,
    :protect_wiki_pages,:edit_own_messages, :delete_own_messages, :view_calendar, :manage_subtasks, :view_issue_watchers, :add_issue_watchers,
      :delete_issue_watchers,:view_documents, :manage_files, :view_files, :view_gantt,:add_issue_notes, :edit_own_issue_notes, :view_private_notes],
        issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true }).first

#Worker - Realizador
wk = Role.seed(:id,
  { id: 6, name: "Realizador", permissions: [:view_files,:view_calendar,:comment_news, :view_issues,:add_issues, :manage_issue_relations, :manage_subtasks,
    :add_issue_notes, :edit_own_issue_notes, :edit_own_time_entries],issues_visibility: "own", users_visibility: "members_of_visible_projects",
      time_entries_visibility: "all", all_roles_managed: false }).first



roles = {default_role_manager: man, default_role_hhrr: hr, default_role_stakeholder: stk, default_role_supervisor: sup, default_role_worker: wk}
roles.each do |translation, model|
  I18n.available_locales.each  do |loc|
    model.attributes = {name: I18n.t!(translation, locale: loc), locale: loc}
  end
  model.save!
end

# I18n.locales.each |loc| do
#   man.attribute name: I18n.t!(:default_role_manager, locale: loc). locale: loc
#   hr.attribute name: I18n.t!(:default_role_hhrr, locale: loc). locale: loc
# end
# man.save!
# hr.save!


# #
# # #Stakeholder - Interesado
# # stk = Role.create(name: "Interesado",permissions: [:view_calendar,:comment_news, :view_issues],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: false)
# #
# # stk.attributes = {name: "Stakeholder", locale: :en}
# # stk.attributes = {name: "Interesado", locale: :es}
# # stk.save!
# # #Supervisor - Supervisor
# # sup = Role.create(name: "Supervisor", permissions: [:edit_issues,:manage_boards, :add_messages,:comment_news, :view_wiki_pages,:edit_wiki_pages, :protect_wiki_pages,:edit_own_messages,
# #   :delete_own_messages, :view_calendar, :manage_subtasks, :view_issue_watchers, :add_issue_watchers, :delete_issue_watchers,:view_documents,
# #   :manage_files, :view_files, :view_gantt,:add_issue_notes, :edit_own_issue_notes, :view_private_notes],issues_visibility: "all", users_visibility: "all", time_entries_visibility: "all", all_roles_managed: true)
# #
# # sup.attributes = {name: "Supervisor", locale: :en}
# # sup.attributes = {name: "Supervisor", locale: :es}
# # sup.save!
# #
# #
# # #Worker - Realizador
# # wk = Role.create(name: "Realizador", permissions: [:view_files,:view_calendar,:comment_news, :view_issues,:add_issues, :manage_issue_relations, :manage_subtasks,
# #   :add_issue_notes, :edit_own_issue_notes, :edit_own_time_entries],issues_visibility: "own", users_visibility: "members_of_visible_projects", time_entries_visibility: "all", all_roles_managed: false)
# #
# # wk.attributes = {name: "Worker", locale: :en}
# # wk.attributes = {name: "Realizador", locale: :es}
# # wk.save!
