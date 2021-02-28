class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to @answer.question, notice: 'Your answer successfully deleted.'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
