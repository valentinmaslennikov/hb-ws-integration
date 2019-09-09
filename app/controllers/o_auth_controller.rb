class OAuthController < ApplicationController
  AccessDenied = Class.new StandardError

  def create
    raise AccessDenied if params[:error].eql?('access_denied')
    Setting.where(var: 'code').first_or_create.update(var: 'code', value: params[:code])
    render 'o_auth/oauth'
  end

  rescue_from AccessDenied do |e|
    head :forbidden
  end
end
