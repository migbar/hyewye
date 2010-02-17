require File.dirname(__FILE__) + '/../spec_helper'

describe Question do
  
  
  describe "structure" do
    should_have_column :body, :type => :string    
  end
  
  describe "associations" do
    should_belong_to :user
    should_have_many :answers
    should_have_one :event, :as => :subject    
  end
  
  describe "validations" do
    should_validate_length_of :body, :maximum => 255
    should_validate_presence_of :body    
  end
    
  describe "creating associated event" do      
    before(:each) do
      Event.delete_all
      @user = Factory.create(:user)
    end
    
    it "creates an asosciated event when it is created successfully" do
      lambda {
        @question = Factory.create(:question, :user => @user)
      }.should change(Event, :count).by(1)
      
      Event.first.subject.should == @question
      @question.event.user.should == @question.user
    end
    
    describe "#save_with_notification" do
      it "notifies the user of event creation" do
        question = Factory.build(:question, :user => @user)
        @user.should_receive(:event_created).with(question)
        question.save_with_notification
      end
    end
  end
  
  describe "answers" do
    def build_question_with_answers
      @question = Factory.create(:question)
      2.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_have]) }
      3.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_would]) }
      5.times { Factory.create(:answer, :question => @question, :choice => Answer.choices[:i_would_never]) }
      @question.reload
    end
    
    describe "#i_have_percent" do
      it "returns the percent of answers having choice i_have" do
        build_question_with_answers
        @question.answers.i_have_percent.should == 20
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_have_percent.should == 0
      end
    end
    
    describe "#i_would_percent" do
      it "returns the percent of answers having choice i_would" do
        build_question_with_answers
        @question.answers.i_would_percent.should == 30
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_would_percent.should == 0
      end
    end
    
    describe "#i_would_never_percent" do
      it "returns the percent of answers having choice i_would_never" do
        build_question_with_answers
        @question.answers.i_would_never_percent.should == 50
      end
      
      it "it returns 0 if no answers defined" do
        @question = Factory.create(:question)
        @question.answers.i_would_never_percent.should == 0
      end
    end
  end
  
  describe "caching" do
    class CacheMock
      def fetch(key, &block)
        yield
      end
    end
    
    before(:each) do
      @cache = CacheMock.new
      Rails.should_receive(:cache).any_number_of_times.and_return(@cache)
      @question = Factory.create(:question)
    end
    
    describe "#i_have_percent" do
      it "calls the count on the answers collection" do
        @question.answers.should_receive(:i_have_percent)
        @question.i_have_percent
      end
      
      it "caches the value with a key scoped to the Question's ID and the choice" do
        Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_have_percent)).and_return(30)
        @question.i_have_percent.should == 30
      end
    end
    
    describe "#i_would_percent" do
      it "calls the count on the answers collection" do
        @question.answers.should_receive(:i_would_percent)
        @question.i_would_percent
      end
      
      it "caches the value with a key scoped to the Question's ID and the choice" do
        Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_would_percent)).and_return(30)
        @question.i_would_percent.should == 30
      end
    end
    
    describe "#i_would_never_percent" do
      it "calls the count on the answers collection" do
        @question.answers.should_receive(:i_would_never_percent)
        @question.i_would_never_percent
      end
      
      it "caches the value with a key scoped to the Question's ID and the choice" do
        Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_would_never_percent)).and_return(30)
        @question.i_would_never_percent.should == 30
      end
    end
  
    it "#percentage_cache_key returns the cache key with the question's id and choice " do
      @question.percentage_cache_key('foo').should == "question:#{@question.id}:foo"
    end
    
    it "#expire_percentages_cache forces a cache miss for each of the choices" do
      Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_have_percent), :force => true)
      Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_would_percent), :force => true)
      Rails.cache.should_receive(:fetch).with(@question.percentage_cache_key(:i_would_never_percent), :force => true)
      @question.expire_percentages_cache
    end
  
  end
  
  it "#to_s returns the body of the question" do
    question = Question.new(:body => "foo")
    question.to_s.should == "foo"
  end
end