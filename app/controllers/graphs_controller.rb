class GraphsController < ApplicationController

	before_filter :sanitize_params

	def cache_graph
		logger.debug("Caching Image")
	end

	def fetch_static_graph
		params.require(:name)
		@chart = Chart.find_by_name(params['name'])
    	respond_to do |format|
      		if(@status)
        		format.html { render template: "graphs/static_graph" }
        		format.json  { render 'generic.json' }
      		else
        		format.html { render template: "graphs/static_graph", :error => "Could not fetch graph #{params['name']} of type #{params['chart_type']}" }
        		format.json  { render 'generic.json' }
      		end
    	end
	end

protected

    def sanitize_params
        params.permit(:authenticity_token, '_', :chart_type, :name)
    end

end
