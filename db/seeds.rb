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
	Recommenders.create(user_id: @user.id, email: "booger-#{i}@farm.com", originally_sent: @date)
	@date = @date + 1.day
end
for i in 51..75
	foo = Recommenders.create(user_id: @user.id, email: "booger-#{i}@farm.com", originally_sent: @date, responded_at: @date + 1.day, response: :accepted)
	@date = @date + 1.day
	foo.response = :accepted
	foo.save
end
for i in 76..100
	foo = Recommenders.create(user_id: @user.id, email: "booger-#{i}@farm.com", originally_sent: @date, responded_at: @date + 1.day, response: :rejected)
	@date = @date + 1.day
	foo.response = :rejected
	foo.save
end

#Users
User.where("email like 'dummy_%'").delete_all
@old_date = DateTime.now - 20.days
for j in 0..19
	for i in 0..60
		u = User.new({email: "dummy_#{(j*60)+i}@example.com", password: SecureRandom.hex, confirmed_at: @old_date, created_at: @old_date})
		u.save
		
		rand = Random.rand(10)
		case rand
		when 0..3
			u.party_affiliation = :democrat
		when 4..7
			u.party_affiliation = :republican
		when 8
			u.party_affiliation = :neither
		when 9
			u.party_affiliation = :no_vote
		end
		u.save
		puts("#{u.email}  #{u.created_at}  #{j}  #{i}")
	end
	@old_date = @old_date + 1.day
end
