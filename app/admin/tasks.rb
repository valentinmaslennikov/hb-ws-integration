ActiveAdmin.register Task do
  action_item :view_site do
    link_to "Sync Tasks", admin_tasks_sync_path, remote: true
  end

  controller do
    require "worksection"

    def sync
      Task.build_tasks_for_user(current_admin_user)
    end

    def scoped_collection
      current_admin_user.tasks
    end
  end
end