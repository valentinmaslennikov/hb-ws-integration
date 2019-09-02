ActiveAdmin.register Project do
  action_item :view_site do
    link_to "Sync", admin_projects_sync_path, remote: true
  end

  controller do
    #require "worksection"

    def sync
      p 'q'
    end

    def scoped_collection

      #client = Worksection::Client.new(Rails.application.credentials.production[:domain_name],
      #                        Rails.application.credentials.production[:worksection_key])
      current_admin_user.projects
    end
  end
end