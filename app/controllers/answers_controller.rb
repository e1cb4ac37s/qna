class AnswersController < ApplicationController
  before_action :authenticate_user!
  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def question
    @question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body)
  end
end
