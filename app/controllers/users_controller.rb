class UsersController < ApplicationController
  before_filter :sanitize_params

  def set_locale
	if(!params[:locale].nil? && !current_user.nil?)
		current_user.locale = params[:locale]
		current_user.save
	end
	redirect_to root_url
  end

  def opt_out
	params.require(:email)
	@user = User.find_by_email(params[:email])
	@err = nil
	if(@user.nil?)
		@err = "Could not locate email in database"
	else
		@user.opt_out_at = DateTime.now
		@status = @user.save
	end
    respond_to do |format|
    	if(@err.nil?)
       		format.html { render template: "pages/opt_out" }
			format.json  { render 'generic.json' }
		else
			format.html { render template: "pages/opt_out", :error => "Could not opt out #{current_user.errors.full_messages}" }
			format.json  { render 'generic.json' }
		end
    end
  end

protected
    def sanitize_params
        params.permit(:authenticity_token, :locale, :email)
    end
end
