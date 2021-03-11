class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  helper_method :question

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new; end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    end
  end

  def set_best_answer
    @answer = Answer.find(params[:answer_id])
    @question = Question.find(params[:id])
    @prev_best_answer = @question.best_answer
    if @question.id == @answer.question_id
      @question.set_best_answer(@answer == @prev_best_answer ? nil : @answer)
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, :file)
  end
end
