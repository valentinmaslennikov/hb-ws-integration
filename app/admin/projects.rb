ActiveAdmin.register Project do
  config.clear_action_items!
  config.filters = false

  controller do

    def scoped_collection
      current_admin_user.projects
    end
  end
end