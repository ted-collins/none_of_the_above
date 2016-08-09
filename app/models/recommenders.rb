class Recommenders < ActiveRecord::Base
  self.per_page = 20

  def self.state
    [:pending, :approved, :rejected]
  end

  before_validation(on: :create) do
    self.response = :pending
    self.responded_at = DateTime.now
  end

end
