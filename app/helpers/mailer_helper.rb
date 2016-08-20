module MailerHelper
    def use_verizon
		Rails.logger.debug("\n\rUsing Verizon\n\r")
		Rails.logger.debug("\n\r#{self.inspect}\n\r")
		
		Rails.config.action_mailer.smtp_settings.address = "smtp.verizon.net"
		Rails.config.action_mailer.smtp_settings.port = 465
		Rails.config.action_mailer.smtp_settings.user_name = 'collins.ted@verizon.net'
		Rails.config.action_mailer.smtp_settings.password = '1muffin2'
    end
end
