ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'site'
  map.resource :account, :controller => "users"
  map.resource :user_session
  map.resources :questions, :has_many => :answers
end
