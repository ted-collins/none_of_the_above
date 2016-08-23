Rails.application.routes.draw do

	match '/blog', to: 'blog#redirect', via: ['options', 'get', 'post']

  	devise_for :users  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
	get "/pages/:page" => "pages#show"
	get "/memes/:page" => "pages#show_meme"
	root 'pages#show', :page => 'home'

  	match 'api/user_details(.:format)', to: 'api#user_details', via: ['options']
  	get 'api/user_details(.:format)' => 'api#user_details', as: 'get_user_details'
  	post 'api/user_party(.:format)' => 'api#set_user_party', as: 'set_user_party'
  	post 'api/user_zipcode(.:format)' => 'api#set_user_zipcode', as: 'set_user_zipcode'
  	post 'api/user_zipcode_reset(.:format)' => 'api#reset_user_zipcode', as: 'reset_user_zipcode'
  	post 'users/set_locale(.:format)' => 'users#set_locale', as: 'users_set_locale'
	get 'api/recommenders_list(.format)' => 'api#recommenders_list', as: 'recommenders_list'
  	post 'api/user_add_email(.:format)' => 'api#add_email', as: 'add_email_for_user'
  	post 'api/user_del_email(.:format)' => 'api#del_email', as: 'del_email_for_user'
	get 'validate(.:format)' => 'recommenders#validate', as: 'validate'
	get 'api/chart(.:format)' => 'api#fetch_chart', as: 'fetch_chart'
	post 'api/chart(.:format)' => 'api#upload_chart', as: 'upload_chart'

	get 'cache_graph(.:format)' => 'graphs#cache_graph', as: 'cache_graph'
	get 'static_graph(.:format)' => 'graphs#fetch_static_graph', as: 'static_graph'
	get 'users/opt_out(.:format)' => 'users#opt_out', as: 'opt_out'

end
