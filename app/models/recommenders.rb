require 'securerandom'
class Recommenders < ActiveRecord::Base
  attr_accessor :originally_sent_in_words
  self.per_page = 20

  validate :must_be_unique_per_user

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

protected
  before_validation(on: :create) do
    self.response = :pending
    self.created_at = DateTime.now
	self.response_token = SecureRandom.base64 + '-' + SecureRandom.base64
  end

  def must_be_unique_per_user
	user = User.find(self.user_id)
	logger.debug("\nChecking whether emailing self #{self.email} vs #{user.email}\n")
	if(self.user_id.nil?)
		errors.add(:base, I18n.t(:InvalidUserId))
		return false
	end
		
	if(self.email.eql?(user.email))
		errors.add(:base, I18n.t(:CannotRecommendSelf))
		return false
	end
	logger.debug("Checking Unique on email #{self.inspect}")
	if(self.id.nil?)
		current_list = Recommenders.where("user_id = ? AND email LIKE ?", user_id, self.email)
	else
		current_list = Recommenders.where("id != ? AND user_id = ? AND email LIKE ?", self.id, user_id, self.email)
	end
	logger.debug("WHERE returned COUNT is #{current_list.count} #{current_list.inspect}")
	if(!current_list.nil? && current_list.count > 0)
		errors.add(:base, I18n.t(:PossibleDuplicate))
		return false
	else
		return true
	end
  end

end
