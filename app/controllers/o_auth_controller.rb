class OAuthController < ApplicationController

  AccessDenied = Class.new StandardError

  def create
    raise AccessDenied if params[:error].eql?('access_denied')
    AdminUser.habstaff_token_sync(params)
    render 'o_auth/oauth'
  end

  rescue_from AccessDenied do |e|
    head :forbidden
  end
end
