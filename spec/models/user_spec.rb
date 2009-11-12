require 'spec_helper'

describe User do
  should_have_column :login, :email, :crypted_password, :password_salt,
                     :persistence_token, :single_access_token, :perishable_token,
                     :type => :string
  should_have_many :questions
  should_have_many :answers
  should_have_many :events
  
  it "#to_s returns the login for the user" do
    user = User.new(:login => 'bob')
    user.to_s.should == 'bob'
  end
end