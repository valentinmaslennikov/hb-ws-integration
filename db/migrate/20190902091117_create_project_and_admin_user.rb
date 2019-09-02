class CreateProjectAndAdminUser < ActiveRecord::Migration[5.2]
  def change
    create_table :admin_users_projects, id: false do |t|
      t.belongs_to :project
      t.belongs_to :admin_user
    end
  end
end
