# Be sure to restart your server when you modify this file.

#Rails.application.config.session_store :cookie_store, key: '_none_of_the_above_session'

require 'action_dispatch/middleware/session/dalli_store'
if Rails.env.production?
NoneOfTheAbove::Application.config.session_store :dalli_store,
	:memcache_server => ['127.0.0.1'], :namespace => 'sess_none_of_the_above', :key => '_base_none_of_the_above', :expire_after => 3.days
elsif Rails.env.jenkins?
NoneOfTheAbove::Application.config.session_store :dalli_store,
	:memcache_server => ['192.168.1.36'], :namespace => 'none_of_the_above_jenk', :key => '_base_none_of_the_above', :expire_after => 3.days
else
NoneOfTheAbove::Application.config.session_store :dalli_store,
	:memcache_server => ['127.0.0.1'], :namespace => 'sess_none_of_the_above', :key => '_base_none_of_the_above', :expire_after => 3.days
end
