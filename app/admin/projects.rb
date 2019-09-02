ActiveAdmin.register Project do
  action_item :view_site do
    link_to "Sync Projects", admin_projects_sync_path, remote: true
  end

  controller do
    require "worksection"

    def sync
      client = Worksection::Client.new(Rails.application.credentials.production[:domain_name],
                                       Rails.application.credentials.production[:worksection_key])
      user_projects = client.get_all_tasks.deep_symbolize_keys[:data]
          .select{|x| x[:user_to][:email].eql?(current_admin_user.email)}
                          .reduce([]) do |sum,x|
                                x[:user_to] = current_admin_user
                                x.except!(:user_from, :date_added, :priority, :date_closed, :date_end, :tags, :date_start)
                                sum.push(x)
      end
      user_projects.map{|u_p| Project.where(page: u_p[:page]).update_or_create(u_p)}
    end

    def scoped_collection
      current_admin_user.projects
    end
  end
end