# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'projects/:project_id/evm_show', to: 'charts#evm_show', as: :project_evm
get 'welcome/help', to: 'welcome#help', as: :welcome_help
get 'default_configs', to: 'default_configs#show', as: :default_configs
post 'load_default_configs', to: 'default_configs#load'
