require File.dirname(__FILE__) + '/../spec_helper'

describe InvitationsController do
  describe "handling POST create" do
    before(:each) do
      @invitation = mock_model(Invitation)
      Invitation.stub(:new).and_return(@invitation)
    end
    
    def post_with_valid_email
      @invitation.should_receive(:save).and_return(true)
      post :create, :email => "foo@example.com"
    end
    
    it "sets the flash message and redirects to the root path on success" do
      post_with_valid_email
      flash[:notice].should == "Thank you for your interest"
      response.should redirect_to(root_path)
    end
  end
end
