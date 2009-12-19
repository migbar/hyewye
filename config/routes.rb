ActionController::Routing::Routes.draw do |map|
  map.resources :invitations, :only => [:new, :create, :index]
  map.root :controller => 'invitations', :action => "new"
  
  map.site_index "/site", :controller => "site", :action => "index"
  # map.root :controller => 'site'  
  
  map.resources :users, :only => [:show] do |user|
    user.resources :questions, :only => [:index]
  end
  map.resource :account, :controller => "users", :only => [:show, :new, :create, :edit, :update]
  map.resource :user_session
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :questions, :has_many => :answers
end
