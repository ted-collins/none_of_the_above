class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable
  validates_format_of :zipcode,
		with: /\A\d{5}-\d{4}|\A\d{5}\z/,
		message: :zipcodeFormat,
		allow_blank: true

  def self.party
    [:neither, :democrat, :republican, :no_vote]
  end

  before_validation(on: :create) do
    self.party_affiliation = :neither
    self.local = :en
  end

end
