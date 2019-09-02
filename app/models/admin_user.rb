class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  has_and_belongs_to_many :projects

  def self.current
    Thread.current[:current_user]
  end

  def self.current=(usr)
    Thread.current[:current_user] = usr
  end
end
