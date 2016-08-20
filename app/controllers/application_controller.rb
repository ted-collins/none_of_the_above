class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :set_user
 
	def set_locale
  		I18n.locale ||= I18n.default_locale
  		#if I18n.locale.eql?(:en) && I18n.locale.eql?(:es)
		#	 I18n.locale = :en
		#end
	end

	def set_user
		@c_user = current_user
	end

end
