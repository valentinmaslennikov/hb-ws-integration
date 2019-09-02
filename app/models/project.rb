class Project < ApplicationRecord
  #belongs_to :user_from, foreign_key: 'user_from_id', class_name: 'AdminUser'
  belongs_to :user_to, foreign_key: 'user_to_id', class_name: 'AdminUser'

  scope :with_user_from, -> (user) { where(user_from: user) }
  scope :with_user_to, -> (user) { where(user_to: user) }

  validates :page, presence: true, uniqueness: true

  def self.update_or_create(attributes)
    assign_or_new(attributes).save
  end

  def self.assign_or_new(attributes)
    obj = first || new
    obj.assign_attributes(attributes)
    obj
  end
end
