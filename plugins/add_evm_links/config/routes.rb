# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'projects/:project_id/evm_show', to: 'charts#evm_show'
get 'default_configs', to: 'default_configs#show', as: :default_configs
