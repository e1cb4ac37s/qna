class AnswersController < ApplicationController
  def show; end

  def new; end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answer_path(@question, @answer)
    else
      render :edit
    end
  end

  def edit; end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
