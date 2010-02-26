# == Schema Information
#
# Table name: questions
#
#  id               :integer(4)      not null, primary key
#  user_id          :integer(4)      indexed
#  body             :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  answers_count    :integer(4)      default(0)
#  hotness          :float           default(0.0)
#  last_answered_at :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Question do
  
  
  describe "structure" do
    should_have_column :body, :type => :string
    should_have_column :hotness, :type => :float, :default => 1.0
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
  
  describe "named scopes" do
    it "hottest returns the questions ordered by hotness" do
      q1 = Factory.create(:question, :hotness => 5, :answers_count => 1)
      q2 = Factory.create(:question, :hotness => 10, :answers_count => 1)
      Factory.create(:question, :hotness => 3, :answers_count => 1)
      
      Question.hottest(2).should == [q2, q1]
    end
    
    it "hottest does not return questions with answers_count of 0" do
      Factory.create(:question, :answers_count => 0)
      Factory.create(:question, :answers_count => 1)
      Question.hottest(2).size.should == 1
    end
  end
  
  it "sets the hotness_decreased_at before create" do
    q = Factory.build(:question)
    now = Time.now
    Time.should_receive(:now).any_number_of_times.and_return(now)
    q.save
    q.hotness_decreased_at.should == now
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
  
  describe "#answer_created" do
    before(:each) do
      @question = Factory.create(:question)
    end
    
    it "expires the percentages cache" do
      @question.should_receive(:expire_percentages_cache)
      @question.answer_created
    end
  end
  
  describe "#update_hotness_delayed" do
    before(:each) do
      @question = Factory.create(:question)
      @question.hotness_decreased_at = 1.day.ago
      @question.save
    end
    
    it "updates the hotness using the created_at timestamp if not answers are present" do
      now = Time.now
      Time.should_receive(:now).any_number_of_times.and_return(now)
      @question.should_receive(:update_hotness).with(now, @question.created_at)
      @question.update_hotness_delayed(now)
    end
    
    it "updates the hotness using the last_answered_at time" do
      now = Time.now
      @question.last_answered_at = 1.hour.ago
      Time.should_receive(:now).any_number_of_times.and_return(now)
      @question.should_receive(:update_hotness).with(now, @question.last_answered_at)
      @question.update_hotness_delayed(now)
    end
    
    it "updates the last_answered_at time with Time.now" do
      now = Time.now
      @question.last_answered_at = 1.hour.ago
      Time.should_receive(:now).any_number_of_times.and_return(now)
      @question.update_hotness_delayed(now)
      @question.last_answered_at.should == now
    end
    
    it "sets the hotness_decreased_at to now" do
      now = Time.now
      Time.should_receive(:now).any_number_of_times.and_return(now)
      @question.update_hotness_delayed(now)
      @question.hotness_decreased_at.should == now
    end
    
    it "saves the question" do
      @question.should_receive(:save!)
      @question.update_hotness_delayed(Time.now)
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
  
  describe "#for_sidebar" do
    before(:each) do
      @hottest_questions = (1..5).map { mock_model(Question) }
    end
    
    it "fetches the hottest 5 questions" do
      Question.should_receive(:hottest).with(5).and_return(@hottest_questions)
      question = Question.for_sidebar
      @hottest_questions.should include(question)
    end
  end
  
  describe "#update_hotness" do
    before(:each) do
      @question = Factory.create(:question)
      
    end
    
    it "updates the hotness coeficient for the question when an answer is created" do
      now = Time.now
      previous = now - 100
      @question.hotness = 20.0
      @question.update_hotness(now, previous)
      @question.hotness.should == 740.0
    end
    
    it "keeps the same hotness if the time difference is below 1.0 second" do
      now = Time.now
      previous = now - 0.5
      @question.hotness = 20.0
      @question.update_hotness(now, previous)
      @question.hotness.should == 20.0      
    end
  end
  
  describe "#update_hotness" do
    before(:each) do
      @questions = (1..5).map { |i| mock_model(Question)}
    end
    
    it "sends #recalculate_hotness to all the questions" do
      @questions.each do |q|
        q.should_receive(:recalculate_hotness)
      end
      Question.should_receive(:all).and_return(@questions)
      Question.update_hotness
    end
  end
  
  describe "#recalculate_hotness" do
    before(:each) do
      @times = (1..3).map { |i| i.hours.ago }
      @answers = @times.map do |time|
        mock_model(Answer, :created_at => time)
      end
      @question = stub_model(Question, :created_at => 1.day.ago, :answers => @answers, :save! => true)
    end
    
    it "updates the hotness going through all the answers" do
      @question.should_receive(:update_hotness).with(@times[0], @question.created_at).ordered
      @question.should_receive(:update_hotness).with(@times[1], @times[0]).ordered
      @question.should_receive(:update_hotness).with(@times[2], @times[1]).ordered
      @question.recalculate_hotness
      
    end
    
    it "saves the question" do
      @question.should_receive(:save!)
      @question.recalculate_hotness
    end
  end
end


