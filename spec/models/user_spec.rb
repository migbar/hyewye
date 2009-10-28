require 'spec_helper'

describe User do
  should_have_column :login, :email, :crypted_password, :password_salt,
                     :persistence_token, :single_access_token, :perishable_token,
                     :type => :string
  should_have_many :questions
  should_have_many :answers
end