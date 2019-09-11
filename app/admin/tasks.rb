require 'hubstaff_client'

ActiveAdmin.register Task do
  config.clear_action_items!
  config.filters = false

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