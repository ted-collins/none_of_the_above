class ApiController < ApplicationController

  skip_before_filter :verify_authenticity_token
  before_filter :sanitize_params, :prep_for_json_response

  def user_details
	
	@data = { 'user' => current_user }

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Party Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Party Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def set_user_party
	params.require('party')
    logger.debug("Params #{params.inspect}\n")
	if(params['party'].eql? 'democrat')
		current_user.party_affiliation = "democrat"
		@status = current_user.save
	elsif(params['party'].eql? 'republican')
		current_user.party_affiliation = "republican"
		@status = current_user.save
	elsif(params['party'].eql? 'no_vote')
		current_user.party_affiliation = "no_vote"
		@status = current_user.save
	elsif(params['party'].eql? 'neither')
		current_user.party_affiliation = "neither"
		@status = current_user.save
	else
		@status = false
		@flash = "Unknown party affiliation #{params['party']}"
	end

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Party Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Party Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

protected
    def prep_for_json_response
        @flash = "No Errors"
        @status = true
        @data = nil
    end

    def sanitize_params
        params.permit(:authenticity_token, :id, :format)
    end
end
