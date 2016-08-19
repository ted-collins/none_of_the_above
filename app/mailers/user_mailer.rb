class UserMailer < ApplicationMailer

  def validate(email, token, user)
	@token = token
    @url  = validate_url({token: token})
	@user = user.email
    mail(to: email, subject: "Requesting your help")
  end

end
