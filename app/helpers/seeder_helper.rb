module SeederHelper

	def seed_one
		#Users
		@cnt = User.count + 1
		@time_slot_hour = DateTime.now.strftime('%k').to_i
		@time_slot_min = DateTime.now.strftime('%M').to_i

		puts("Hour #{@time_slot_hour} #{@time_slot_min}")
		case @time_slot_hour
		when 0,2,4,6,7,10,12,14,16,18,20
			puts("Even Hour")
			if @time_slot_min.even?
				puts("Even Min")
				@party=:democrat
			else
				puts("Odd Min")
				@party=:republican
			end
		when 1,3,5,7,9,11,13,15,17,19,21
			puts("Odd Hour")
			if @time_slot_min.even?
				puts("Even Min")
				@party=:republican
			else
				puts("Odd Min")
				@party=:democrat
			end
		when 22
			puts("22 Hour")
			@party=:neither
		when 23
			puts("23 Hour")
			@party=:novote
		end

		@state_seed = Random.rand(3000)
		puts("RANDOM state is #{@state_seed}")
		case @state_seed
		when 0..382
			@state = :CA
		when 383..647
			@state = :TX
		when 648..842
			@state = :NY
		when 843..1038
			@state = :FL
		when 1039..1166
			@state = :IL
		when 1167..1294
			@state = :PA
		when 1295..1491
			@state = :OH
		when 1492..1536
			@state = :GA
		when 1537..1635
			@state = :MI
		when 1636..1733
			@state = :NC
		when 1734..1831
			@state = :NJ
		when 1832..1919
			@state = :VA
		when 1920..2001
			@state = :WA
		when 2002..2070
			@state = :MA
		when 2071..2136
			@state = :AZ
		when 2137..2202
			@state = :IN
		when 2203..2267
			@state = :TN
		when 2268..2231
			@state = :MO
		when 2232..2391
			@state = :MD
		when 2392..2450
			@state = :WI
		when 2451..2507
			@state = :MN
		when 2506..2561
			@state = :CO
		when 2562..2613
			@state = :AL
		when 2614..2661
			@state = :SC
		when 2662..2708
			@state = :LA
		when 2709..2754
			@state = :KY
		when 2755..2797
			@state = :OR
		when 2798..2835
			@state = :OK
		when 2836..2873
			@state = :CT
		when 2874..2908
			@state = :IA
		when 2909..2938
			@state = :MS
		when 2939..2967
			@state = :AR
		when 2968..2996
			@state = :UT
		when 2997..3025
			@state = :KS
		when 2026..3053
			@state = :NV
		when 3054..3080
			@state = :NM
		when 3081..3100
			@state = :NE
		when 3101..3118
			@state = :WV
		when 3119..3136
			@state = :ID
		when 3137..3152
			@state = :HI
		when 3153..3166
			@state = :ME
		when 3167..3179
			@state = :NH
		when 3180..3192
			@state = :RI
		when 3193..3202
			@state = :MT
		when 3203..3212
			@state = :DE
		when 3213..3221
			@state = :SD
		when 3222..3230
			@state = :AK
		when 3229..3236
			@state = :ND
		when 2337..3243
			@state = :DC
		when 3244..3249
			@state = :VT
		when 3250..3256
			@state = :WY
		else
			@state = :NONE
		end

		if(@state != :NONE)
			puts("  Doing #{@state}")
			u = User.new({email: "dummy_#{@cnt}@example.com", password: SecureRandom.hex, confirmed_at: DateTime.now, created_at: DateTime.now, party_affiliation: @party, state_abbreviation: @state.to_s})
			u.save
					
			puts("#{u.email}  #{u.created_at} #{u.state_abbreviation.to_s} #{u.party_affiliation} #{u.errors.full_messages}")
		end
	end
end
