class AddHubstaffIdToItems < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :hubstaff_id, :string
    add_column :admin_users, :user_id, :string
    add_column :tasks, :hubstaff_id, :string
  end
end
