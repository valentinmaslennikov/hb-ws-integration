Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  get '/admin/projects/sync', to: 'admin/projects#sync', as: :admin_projects_sync
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
