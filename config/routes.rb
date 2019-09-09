Rails.application.routes.draw do
  get 'o_auth_controller/create'
  devise_for :admin_users, ActiveAdmin::Devise.config
  get '/admin/projects/sync', to: 'admin/projects#sync', as: :admin_projects_sync
  get '/admin/tasks/sync', to: 'admin/tasks#sync', as: :admin_tasks_sync
  get '/oauth', to: 'o_auth#create'

  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
