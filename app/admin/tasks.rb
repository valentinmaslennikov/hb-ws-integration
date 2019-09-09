require 'hubstaff_client'

ActiveAdmin.register Task do
  config.clear_action_items!
  config.filters = false

  action_item :sync do
    link_to "Sync", admin_tasks_sync_path, remote: true
  end

  action_item :hb_authorise do
    link_to "Authorise on Hubstaff", HubstaffClient.new.start_auth_code_url, target: '_blank'
  end

  controller do
    require "worksection"

    def sync
      Task.build_tasks_for_current(current_admin_user)
    end

    def scoped_collection
      current_admin_user.tasks
    end
  end
end