class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :page
      t.string :status

      t.integer :user_from_id
      t.integer :user_to_id

      t.timestamps
    end
    add_foreign_key :projects, :admin_users, column: :user_from_id
    add_foreign_key :projects, :admin_users, column: :user_to_id
  end
end
