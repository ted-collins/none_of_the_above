class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.party
    [:neither, :democrat, :republican, :no_vote]
  end

  before_validation(on: :create) do
    self.party_affiliation = :neither
  end

end
