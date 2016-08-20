class UserMailer < ApplicationMailer

  def validate(email, token, user)
	@token = token
    @url  = validate_url({token: token})
	@user = user.email
	
	Rails.logger.debug("\r\nUSER MAILER #{email}\r\n")
  	if(!email.nil?)
        use_verizon if((email =~ /comcast/i) != nil)
        use_verizon if((email =~ /playrific/i) != nil)
  	end
    mail(to: email, subject: "Requesting your help")
  end

  def use_verizon
	Rails.logger.debug("\n\rUsing Verizon\n\r")
	
	ActionMailer::Base.default smtp_settings[:address] => "smtp.verizon.net"
	ActionMailer::Base.default smtp_settings[:port] => 465
	ActionMailer::Base.default smtp_settings[:user_name] => 'collins.ted@verizon.net'
	ActionMailer::Base.default smtp_settings[:password] => '1muffin2'
  end

end
