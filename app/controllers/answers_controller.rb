class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  def show; end

  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.new(answer_params.merge(question_id: @question.id))
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      redirect_to @question, notice: 'Answer is invalid, try again'
    end
  end

  def edit; end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.owns?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
