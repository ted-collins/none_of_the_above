# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Recommenders
@user = User.where(email: 'collins.ted@gmail.com').first
for i in 1..100
	Recommenders.create(user_id: @user.id, email: "booger-#{i}@farm.com")
end
