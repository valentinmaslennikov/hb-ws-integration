class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  def self.current
    Thread.current[:current_user]
  end

  def projects
    Project.with_user_to(self)
  end

  def tasks
    Task.with_user_to(self)
  end

  def self.current=(usr)
    Thread.current[:current_user] = usr
  end
end
