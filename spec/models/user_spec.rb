require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe '#author_of?' do
    subject { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { subject.questions.create(attributes_for(:question)) }
    let(:question_of_another_user) { another_user.questions.create(attributes_for(:question)) }

    it 'returns true if entity is created by tested user' do
      expect(subject).to be_author_of(question)
    end

    it 'returns false if entity is created by another user' do
      expect(subject).not_to be_author_of(question_of_another_user)
    end

    it 'should return false if no entity passed' do
      expect(subject).not_to be_author_of(nil)
    end
  end
end