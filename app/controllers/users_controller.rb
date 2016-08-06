class UsersController < ApplicationController
  before_filter :sanitize_params

  def set_locale
	if(!params[:locale].nil? && !current_user.nil?)
		current_user.locale = params[:locale]
		current_user.save
	end
	redirect_to root_url
  end

protected
    def sanitize_params
        params.permit(:authenticity_token, :locale)
    end
end
