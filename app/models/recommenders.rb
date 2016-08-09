require 'securerandom'
class Recommenders < ActiveRecord::Base
  attr_accessor :originally_sent_in_words
  self.per_page = 20

  def self.state
    [:pending, :approved, :rejected]
  end

  # Send an invite
  def dispatchEmail(email)
	logger.debug("#{current_user.email} Sending email invite to #{email}")
	rec = Recommender.new
	rec.email = email
	rec.user_id = current_user.id
	return rec.save
  end

  before_validation(on: :create) do
    self.response = :pending
    self.created_at = DateTime.now
	self.response_token = SecureRandom.base64 + '-' + SecureRandom.base64
  end

end
