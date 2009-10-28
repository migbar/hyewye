class AnswersController < ApplicationController
  before_filter :require_user
  before_filter :find_question
  
  def index
    @answer = Answer.new
  end
  
  def create
    @answer = @question.answers.build(params[:answer])
    @answer.user = current_user
    if @answer.save
      flash[:notice] = "Thanks for answering!"
      redirect_to question_answers_path(@question)
    else
      render :index
    end

  end
  
  private
    def find_question
      @question = Question.find(params[:question_id])
    end
end