class ApiController < ApplicationController

  include ApiHelper

  # skip_before_filter :verify_authenticity_token
  before_filter :sanitize_params, :prep_for_json_response

  def user_details
	
	@resp = current_user.attributes.to_options
	sent_count = Recommenders.where("user_id = #{current_user.id} AND responded_at IS NULL").count
	confirmed_count = Recommenders.where("user_id = #{current_user.id} AND responded_at IS NOT NULL").count
	@resp.merge!({friends_sent: sent_count, friends_confirmed: confirmed_count})
	logger.debug("RESP #{@resp.inspect}")
	@data = { 'user' => @resp }

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

  def add_email
	params.require(:email)
    # logger.debug("Params #{params.inspect}\n")
	# Invite friend to recommend user

	@flash = ''
 	@rec = Recommenders.new({user_id: current_user.id, email: params[:email]})
	@user = current_user.email
	begin
		@status = @rec.save
		if(!@status)
			@flash = @rec.errors.full_messages
		end
		@rec_send = @rec.attributes.to_options
		@rec_send.merge!({originally_sent_in_words: time_ago_in_words(DateTime.now)})
		@flash = @rec.errors.full_messages
		@data = @rec_send
	rescue
		@status = false
		if(@rec.errors.any?)
			@flash = @rec.errors.full_messages
		else
			@flash = t(:PossibleDuplicate)
		end
	end

	if(@status)
		@mail_status = UserMailer.validate(params[:email], @rec.response_token, current_user).deliver_later
		if(@mail_status.nil? || @mail_status.job_id.nil?)
			@flash = 'Booger'
			@status = false
		else
			@rec.originally_sent = DateTime.now
			@status = @rec.save
			if(!@status)
				@flash = @rec.errors.full_messages
			end
		end
	end

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Add Email Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Add Email Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def del_email
	params.require(:id)
    # logger.debug("Params #{params.inspect}\n")
	# Invite friend to recommend user

	@flash = ''
 	@rec = Recommenders.find(params[:id])
	if(@rec.nil? || @rec.user_id != current_user.id)
		@flash = t(:CannotDeleteEmail)
		@status = false
		@data = {}
	else
		@rec.delete
		if(@rec.errors.any?)
			@flash = t(:CannotDeleteEmail)
			@status = false
			@data = {}
		else
			@flash = ''
			@status = true
			@data = @rec.attributes.to_options
			@data.merge!({originally_sent_in_words: time_ago_in_words(DateTime.now)})
		end
	end

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Del Email Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Del Email Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def recommenders_list
	params.require(:page)

	@rec_list = current_user.recommenders(params[:page])
	@arr = []
	@rec_list.each { |r|
		base_list = r.attributes.to_options
		if(r.originally_sent.nil?)
			base_list.merge!({originally_sent_in_words: t(:InProcess)})
		else
			base_list.merge!({originally_sent_in_words: time_ago_in_words(r.originally_sent)})
		end
		@arr.push(base_list)
	}
	@data = {list: @arr}
	@data.merge!({page: params[:page]})
    logger.debug("Getting Recommenders For #{current_user.email}")

	@status = true
	@flash = current_user.errors.full_messages
    logger.debug("Returning #{@arr.count} entries")

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Recommenders Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Recommenders Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def fetch_chart
	params.require(:chart_type)

	@data = fetch_users_chart_data(params[:chart_type]) 
	@status = true
	@flash = ''

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Fetch Chart Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Fetch Chart Failed' }
        format.json  { render 'generic.json' }
      end
    end
  end

  def upload_chart
	params.require(:chart_type)
	params.require(:name)
	params.require(:uri)

	@data = ''
	@status = true
	@flash = ''

	rec = Chart.find_by_name(params['name'])
	if(rec.nil?)
		rec = Chart.new(name: params['name'])
	end
	rec.chart_type =  params['chart_type']
	rec.original_filename = params['name']
	rec.content_type = 'image/png'
	rec.image_data = params['uri'].split(',')[1]
	logger.debug("Received URI #{params['name']}")
	@status = rec.save
	logger.debug("URI SAVE is #{@status} ERRORS #{rec.errors.full_messages}")

    respond_to do |format|
      if(@status)
        format.html { redirect_to root_path, :notice => 'Upload Chart Success' }
        format.json  { render 'generic.json' }
      else
        format.html { redirect_to root_path, :error => 'Upload Chart Failed' }
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
        params.permit(:authenticity_token, :id, :format, :zipcode, :party, :place_name, :state_abbreviation, :email, :page, '_', :chart_type,:uri,:name)
    end
end
