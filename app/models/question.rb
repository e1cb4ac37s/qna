class Question < ApplicationRecord
  belongs_to :user
  has_many :answers

  validates :title, :body, presence: true
  validates :title, length: { maximum: 255 }
end
