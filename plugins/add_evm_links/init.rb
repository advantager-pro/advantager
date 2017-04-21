Redmine::Plugin.register :add_evm_links do
  name 'Add EVM Links plugin'
  author 'Advantager Team'
  description 'Add EVM links to menus'
  version '0.0.1'
  url 'http://advantager.pro'
  author_url 'http://advantager.pro'

  permission :view_evm_charts, { charts:  [:evm_show] }

  menu :project_menu, :earned_value, { controller: 'charts', action: 'evm_show', copy_from: nil }, 
    param: :project_id, caption: :evm_section, after: :overview
end
