class AnswersController < ApplicationController
  before_filter :require_user, :except => :index
  before_filter :find_question
  
  def index
    fetch_answers
    @answer = Answer.new
  end
  
  def create
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @answer.save
      flash[:notice] = "Thanks for answering!"
      redirect_to question_answers_path(@question)
    else
      fetch_answers
      render :index
    end
  end
  
  private
    def fetch_answers
      @answers = @question.answers.latest.paginate(:page => params[:page], :per_page => 15)
    end

    def find_question
      @question = Question.find(params[:question_id])
    end
end