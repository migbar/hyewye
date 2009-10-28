require File.dirname(__FILE__) + '/../spec_helper'

describe Question do
  should_have_column :body, :type => :string
  should_belong_to :user
  should_validate_length_of :body, :maximum => 140
  should_validate_presence_of :body
  should_have_many :answers
end