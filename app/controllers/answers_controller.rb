class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: %i[update destroy delete_attachment]
  def create
    @question = Question.find(params[:question_id])
    @answer = current_user.answers.create(answer_params.merge(question_id: question.id))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def delete_attachment
    @file = @answer.files.find(params[:file_id])
    @file.purge
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def question
    @question
  end

  helper_method :question

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end
end
