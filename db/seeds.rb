# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Users

@records = User.where("created_at >= '2016-08-17' AND created_at < '2016-08-18'")
@records.each do | r |
	r.state_abbreviation = null
	r.save
end
