class QuestionsController < ApplicationController
  before_filter :require_user
  
  def new
    @question = Question.new
  end
  
  def create
    @question = current_user.questions.build(params[:question])
    
    if @question.save
      flash[:notice] = "thanks for asking!"
      redirect_to root_path
    else
      render :new
    end
  end
end