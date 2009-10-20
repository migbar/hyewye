require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  describe "handing GET new" do
    def do_get
      get :new
    end
    
    it "renders the new template" do
      do_get
      response.should render_template(:new)
    end
  end
end