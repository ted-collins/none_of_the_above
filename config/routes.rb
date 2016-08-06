Rails.application.routes.draw do

	match '/blog', to: 'blog#redirect'

  	devise_for :users  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
	get "/pages/:page" => "pages#show"
	root 'pages#show', :page => 'home'

  	match 'api/user_details(.:format)', to: 'api#user_details', via: ['options']
  	get 'api/user_details(.:format)' => 'api#user_details', as: 'api/user_details'
  	post 'api/user_party(.:format)' => 'api#set_user_party', as: 'api/set_user_party'
  	post 'api/user_zipcode(.:format)' => 'api#set_user_zipcode', as: 'api/set_user_zipcode'
  	post 'api/user_zipcode_reset(.:format)' => 'api#reset_user_zipcode', as: 'api/reset_user_zipcode'
  	post 'users/set_locale(.:format)' => 'users#set_locale', as: 'users_set_locale'

end
