require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper
include SeederHelper

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_format_of :zipcode,
		with: /\A\d{5}-\d{4}|\A\d{5}\z/,
		message: :zipcodeFormat,
		allow_blank: true

  def recommenders(page)
	@recommenders = Recommenders.where(user_id: id).paginate(:page => page, :per_page => 20)
	return(@recommenders)
  end

  def self.seed
	return seed_one
  end

  def self.party
    [:neither, :democrat, :republican, :no_vote]
  end

  before_validation(on: :create) do
    self.party_affiliation = :neither if self.party_affiliation.nil?
    self.locale |= :en
  end

end
