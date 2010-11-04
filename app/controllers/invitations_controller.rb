class InvitationsController < InheritedResources::Base
  include InheritedResources::DSL

  actions :new, :create
  
  create! do |success, failure|
    success.html do
      flash[:notice] = "Thank you for your interest"
      redirect_to root_path
    end    
  end
 
end