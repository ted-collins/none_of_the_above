class ApiController < ApplicationController

  # skip_before_filter :verify_authenticity_token
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

  def reset_user_zipcode
    logger.debug("Params #{params.inspect}\n")
	# Check Zipcode here

	current_user.zipcode = nil
	current_user.place_name = nil
	current_user.state_abbreviation = nil
	@status = current_user.save
	@flash = current_user.errors.full_messages
    logger.debug("Saving User\n")

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Zipcode Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Zipcode Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def set_user_zipcode
    logger.debug("Params #{params.inspect}\n")
	params.require(:zipcode)
	params.require(:place_name)
	params.require(:state_abbreviation)
	# Check Zipcode here

	current_user.zipcode = params[:zipcode]
	current_user.place_name = params[:place_name]
	current_user.state_abbreviation = params[:state_abbreviation]
    logger.debug("Setting User Zipcode #{current_user.zipcode}")
    logger.debug("Setting User Place Name #{current_user.place_name}")
    logger.debug("Setting User State Abbreviation #{current_user.state_abbreviation}")
	@status = current_user.save
	@flash = current_user.errors.full_messages
    logger.debug("Saving User\n")

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Zipcode Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Zipcode Failed' }
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
        params.permit(:authenticity_token, :id, :format, :zipcode, :party, :place_name, :state_abbreviation)
    end
end
