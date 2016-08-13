include CityStateHelper

module ApiHelper
	def fetch_users_chart_data(chart_type)
		logger.debug("Fetching Chart #{chart_type}")
		case chart_type.to_i
		when 0
			return(fetch_user_signups)
		when 1
			return(fetch_total_users)
		when 2
			return(fetch_balance_of_users)
		when 3
			return(fetch_users_by_state)
		else
			return "Error--Unknown Chart Type #{chart_type}"
		end
	end
		
protected
	def fetch_user_signups
		logger.debug("Fetching User Signups")
		arr_date = []
		arr_value_dem = []
		arr_value_rep = []
		arr_value_und = []
		arr_value_not = []
		for i in 0..19
			qu_end = (DateTime.now - (19 - i).days).strftime("%Y-%m-%d")
			qu_start = (DateTime.now - (20 - i).days).strftime("%Y-%m-%d")
			arr_value_dem[19 - i] = User.where("created_at > '#{qu_start}' AND created_at <= '#{qu_end}' AND party_affiliation = 'democrat'").count
			arr_value_rep[19 - i] = User.where("created_at > '#{qu_start}' AND created_at <= '#{qu_end}' AND party_affiliation = 'republican'").count
			arr_value_und[19 - i] = User.where("created_at > '#{qu_start}' AND created_at <= '#{qu_end}' AND party_affiliation = 'neither'").count
			arr_value_not[19 - i] = User.where("created_at > '#{qu_start}' AND created_at <= '#{qu_end}' AND party_affiliation = 'no_vote'").count
			arr_date[i] = (DateTime.now - (19 - i).days).strftime("%b %d")
		end
		return { dates: arr_date,
				 values_dem: arr_value_dem,
				 values_rep: arr_value_rep,
				 values_und: arr_value_und,
				 values_not: arr_value_not
				}
	end

	def fetch_total_users
		logger.debug("Fetching Total Users")
		arr_date = []
		arr_value_dem = []
		arr_value_rep = []
		arr_value_oth = []
		arr_value_goal = []
		for i in 0..19
			qu_start = (DateTime.now - (20 - i).days).strftime("%Y-%m-%d")
			arr_value_dem[i] = User.where("created_at <= '#{qu_start}' AND party_affiliation = 'democrat'").count
			arr_value_rep[i] = User.where("created_at <= '#{qu_start}' AND party_affiliation = 'republican'").count
			arr_value_oth[i] = User.where("created_at <= '#{qu_start}' AND party_affiliation != 'democrat' AND party_affiliation != 'republican'").count
			arr_date[i] = (DateTime.now - (19 - i).days).strftime("%b %d")
			arr_value_goal[i] = 2000
		end
		return { dates: arr_date,
				 values_dem: arr_value_dem,
				 values_rep: arr_value_rep,
				 values_oth: arr_value_oth,
				 values_goal: arr_value_goal
				}
	end

	def fetch_balance_of_users
		logger.debug("Fetching Balance Of Users")
		arr_date = []
		arr_value_bal = []
		for i in 0..19
			qu_start = (DateTime.now - (20 - i).days).strftime("%Y-%m-%d")
			arr_value_bal[i] = (User.where("created_at <= '#{qu_start}' AND party_affiliation = 'democrat'").count - User.where("created_at <= '#{qu_start}' AND party_affiliation = 'republican'").count)
			arr_date[i] = (DateTime.now - (19 - i).days).strftime("%b %d")
		end
		return { dates: arr_date,
				 values_bal: arr_value_bal,
				}
	end

	def fetch_users_by_state
		logger.debug("Fetching Users By State")
		arr_state = []
		arr_value_tot = []
		arr_value_dem = []
		arr_value_rep = []
		arr_value_und = []
		state_names = CS.states(:us)
		i = 0
		state_names.each do |state_abbr, state_full|
			arr_value_tot[i] = User.where("state_abbreviation like \"#{state_abbr}%\"").count
			arr_value_dem[i] = User.where("state_abbreviation like \"#{state_abbr}%\" AND party_affiliation like \"democrat%\"").count
			arr_value_rep[i] = User.where("state_abbreviation like \"#{state_abbr}%\" AND party_affiliation like \"republican%\"").count
			arr_value_und[i] = User.where("state_abbreviation like \"#{state_abbr}%\" AND party_affiliation NOT like \"republican%\" AND party_affiliation NOT like \"democrat%\"").count
			arr_state[i] = "US-#{state_abbr}"
			i += 1
		end
		return { states: arr_state,
				 values_tot: arr_value_tot,
				 values_dem: arr_value_dem,
				 values_rep: arr_value_rep,
				 values_und: arr_value_und
				}
	end
end
