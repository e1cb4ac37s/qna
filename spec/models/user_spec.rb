require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers) }
  it { should have_many(:questions) }

  describe 'owns? method' do
    subject { create(:user) }
    it 'should return true if entity is created by tested user' do
      question = subject.questions.create(attributes_for(:question))
      expect(subject.owns?(question)).to be true
    end
    it 'should return false if entity is created by user, other than tested one' do
      another_user = create(:user)
      question = another_user.questions.create(attributes_for(:question))
      expect(subject.owns?(question)).to be false
      expect(another_user.owns?(question)).to be true
    end
    it 'should return false if no entity passed' do
      expect(subject.owns?(nil)).to be false
    end
  end
end