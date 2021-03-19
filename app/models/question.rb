class Question < ApplicationRecord
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :answers
  has_many_attached :files

  validates :title, :body, presence: true
  validates :title, length: { maximum: 255 }

  def set_best_answer(answer)
    if answer.nil? || answer.question_id == id
      update(best_answer: answer)
    else
      raise ArgumentError, 'Invalid answer passed. Make sure best answer belongs to question or is nil to unset.'
    end
  end
end
