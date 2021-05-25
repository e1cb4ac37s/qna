class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  before_destroy :clear_best_answer
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :body, :question, presence: true

  def best_answer_of?(question)
    question.best_answer_id == id
  end

  private

  def clear_best_answer
    if best_answer_of?(question)
      question.update(best_answer: nil)
    end
  end
end
