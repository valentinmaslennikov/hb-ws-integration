class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

  def self.current
    Thread.current[:current_user]
  end

  def self.habstaff_token_sync(params)
    response = HubstaffClient.new.access_token_request params[:code]
    raise StandardError, response.parsed_response['error'],
          response.parsed_response['error_description'] unless response.code.eql?(200)
    res = response.symbolize_keys
    me = HubstaffClient.new.me(res[:access_token]).deep_symbolize_keys
    current_user = AdminUser.find_by_email(me[:user][:email])
    res.merge!(user_id: HubstaffClient.new.me(res[:access_token]).deep_symbolize_keys[:user][:id])
    current_user.update_attributes(res)
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
