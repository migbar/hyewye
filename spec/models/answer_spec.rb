require 'spec_helper'

describe Answer do
  should_have_column :choice, :type => :integer
  should_have_column :body, :type => :string
  should_belong_to :user
  should_belong_to :question
  should_validate_presence_of :body
  should_validate_length_of :body, :maximum => 140
end
