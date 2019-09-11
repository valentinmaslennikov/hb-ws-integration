class AddTokensToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :access_token, :string
    add_column :admin_users, :refresh_token, :string
    add_column :admin_users, :token_type, :string
    add_column :admin_users, :expires_in, :integer
    add_column :admin_users, :role, :string, default: 'user'
  end
end
