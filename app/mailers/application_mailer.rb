require 'digest/sha2'
class ApplicationMailer < ActionMailer::Base
  default from: "support@oftheabove.com"
  default "Message-ID"=>"#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@oftheabove.com>"

  layout 'mailer'

end
