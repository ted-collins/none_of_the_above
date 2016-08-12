class Generator < ActiveRecord::Base

	def self.scan
		#puts("Generator--Scanning\n")
		party = DateTime.now.to_i.even? ? 'democrat' : 'republican'
		#u = User.new({email: "dummy_user-#{User.count}@example.com", confirmed_at: DateTime.now, party_affiliation: party, password: SecureRandom.hex})
		#u.party_affiliation = party
		#u.save
		#puts("Generator errors #{u.errors.inspect}")
	end
end
