ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'site'
  map.resource :account, :controller => "users", :only => [:new, :create]
  map.resources :users, :only => [:show]
  map.resource :user_session
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :questions, :has_many => :answers
end
