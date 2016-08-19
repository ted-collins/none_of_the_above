class UserMailer < ApplicationMailer
  def validate(email, token, user)
	@token = token
    @url  = validate_url({token: token})
	@user = user.email
    mail(to: email, subject: "The person with email #{user.email} requests your help")
  end

end
