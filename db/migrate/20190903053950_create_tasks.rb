class CreateTasks < ActiveRecord::Migration[5.2]
  def change
    create_table :tasks do |t|
      t.string :page
      t.string :name
      t.string :status

      t.integer :user_from_id
      t.integer :user_to_id

      t.timestamps
    end

    add_foreign_key :tasks, :admin_users, column: :user_from_id
    add_foreign_key :tasks, :admin_users, column: :user_to_id
  end
end
