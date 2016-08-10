class RecommendersController < ApplicationController
    before_filter :sanitize_params
    def set_locale
		if(!params[:locale].nil? && !current_user.nil?)
			current_user.locale = params[:locale]
			current_user.save
		end
  	end

	def validate
		params.permit(:token)

		logger.debug("Checking for token #{params[:token]}")
		rec = Recommenders.find_by_response_token(params[:token])
		logger.debug(" FIND #{rec.inspect}")
		if(rec.nil?)
			redirect_to root_url
		else
			rec.response = :approved
			@status = rec.save
    		respond_to do |format|
	      		if(@status)
        			format.html { render 'recommenders/validate', :notice => 'Validation Success' }
        			format.json  { render 'generic.json' }
      			else
        			format.html { render 'recommenders/validate', :error => 'Validation Failed' }
        			format.json  { render 'generic.json' }
      			end
      		end
		end
    end

protected
    def sanitize_params
        params.permit(:authenticity_token, :locale, :token)
    end

end
