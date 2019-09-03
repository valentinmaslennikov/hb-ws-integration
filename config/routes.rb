Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  get '/admin/projects/sync', to: 'admin/projects#sync', as: :admin_projects_sync
  get '/admin/tasks/sync', to: 'admin/tasks#sync', as: :admin_tasks_sync
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
