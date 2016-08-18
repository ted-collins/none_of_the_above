# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Recommenders
Recommenders.delete_all
@date = DateTime.now - 200.days
@user = User.where(email: 'collins.ted@gmail.com').first
for i in 1..50
	Recommenders.create(user_id: @user.id, email: "booger-#{i}@example.com", originally_sent: @date)
	@date = @date + 1.day
end
for i in 51..75
	foo = Recommenders.create(user_id: @user.id, email: "booger-#{i}@example.com", originally_sent: @date, responded_at: @date + 1.day, response: :accepted)
	@date = @date + 1.day
	foo.response = :accepted
	foo.save
end
for i in 76..100
	foo = Recommenders.create(user_id: @user.id, email: "booger-#{i}@example.com", originally_sent: @date, responded_at: @date + 1.day, response: :rejected)
	@date = @date + 1.day
	foo.response = :rejected
	foo.save
end

#Users
User.where("email like 'dummy_%'").delete_all

if Rails.env.production?
	@states = {:CA=>383, :TX=>264, :NY=>196, :FL=>195, :IL=>128, :PA=>127, :OH=>115, :GA=>99, :MI=>98, :NC=>98, :NJ=>88, :VA=>82, :WA=>69, :MA=>66, :AZ=>66, :IN=>65, :TN=>64, :MO=>60, :MD=>59, :WI=>57, :MN=>54, :CO=>52, :AL=>48, :SC=>47, :LA=>46, :KY=>43, :OR=>39, :OK=>38, :CT=>35, :IA=>30, :MS=>29, :AR=>29, :UT=>29, :KS=>28, :NV=>27, :NM=>20, :NE=>18, :WV=>18, :ID=>16, :HI=>14, :ME=>13, :NH=>13, :RI=>10, :MT=>10, :DE=>9, :SD=>8, :AK=>7, :ND=>7, :DC=>6, :VT=>6, :WY=>5}
	@max_i = 1
else
	@states = {:CA=>1, :TX=>1, :NY=>1, :FL=>1, :IL=>1, :PA=>1, :OH=>1, :GA=>1, :MI=>1, :NC=>1, :NJ=>1, :VA=>1, :WA=>1, :MA=>1, :AZ=>1, :IN=>1, :TN=>1, :MO=>1, :MD=>1, :WI=>1, :MN=>1, :CO=>1, :AL=>1, :SC=>1, :LA=>1, :KY=>1, :OR=>1, :OK=>1, :CT=>1, :IA=>1, :MS=>1, :AR=>1, :UT=>1, :KS=>1, :NV=>1, :NM=>1, :NE=>1, :WV=>1, :ID=>1, :HI=>1, :ME=>1, :NH=>1, :RI=>1, :MT=>1, :DE=>1, :SD=>1, :AK=>1, :ND=>1, :DC=>1, :VT=>1, :WY=>1}
	@max_i = 1
end

cnt=0
@states.each do |k,v|
	puts("  Doing #{k} #{v}")
	v.times do
		@old_date = DateTime.now - 20.days
		@party = :neither
		for j in 0..19
			for i in 0..@max_i
				rand = Random.rand(10)
				case rand
				when 0..3
					@party = :democrat
				when 4..7
					@party = :republican
				when 8
					@party = :neither
				when 9
					@party = :no_vote
				end
				u = User.new({email: "dummy_#{cnt}@example.com", password: SecureRandom.hex, confirmed_at: @old_date, created_at: @old_date, party_affiliation: @party, state_abbreviation: k.to_s})
				u.save
			
				puts("#{u.email}  #{u.created_at} #{k.to_s} #{u.party_affiliation} #{u.errors.full_messages}")
				cnt += 1
			end
			@old_date = @old_date + 1.day
		end
	end
end
