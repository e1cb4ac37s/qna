require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:links) }
  it { should belong_to :user }
  it { should belong_to(:best_answer).optional }

  it { should validate_presence_of :title }
  it { should validate_length_of(:title).is_at_most(255) }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'has many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#set_best_answer' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }

    it "sets it's best answer" do
      question.set_best_answer(answer)

      expect(answer).to be_best_answer_of(question)
    end

    it "replaces best answer on subsequent sets" do
      question.set_best_answer(answer)
      another_answer = create(:answer, user: user, question: question)
      question.set_best_answer(another_answer)

      expect(answer).not_to be_best_answer_of(question)
      expect(another_answer).to be_best_answer_of(question)
    end

    it "can't set other question's answer as best" do
      another_question = create(:question, user: user)
      expect { another_question.set_best_answer(answer) }.to raise_error(ArgumentError)
    end

    # I suspect it'll be useful feature to be able to uncheck best answer in future iterations
    it "can set nil as best answer" do
      question.set_best_answer(nil)
      expect(question.best_answer).to be_nil
    end
  end
end
