class QuestionsController < ApplicationController
  before_filter :require_user, :except => :show
  
  def new
    @question = Question.new
  end
  
  def show
    @question = Question.find(params[:id])
    redirect_to question_answers_path(@question)
  end
  
  def create
    @question = current_user.questions.build(params[:question])
    
    if @question.save_with_notification
      flash[:notice] = "thanks for asking!"
      redirect_to root_path
    else
      render :new
    end
  end
end