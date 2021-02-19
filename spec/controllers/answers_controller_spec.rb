require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }

  describe 'GET #show' do
    let(:answer) { question.answers.create(body: 'MyText', user_id: user.id) }
    before { get :show, params: { question_id: question, id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    describe 'by authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        before do
          @params = { question_id: question.id, answer: { body: 'MyText' } }
        end

        it 'saves a new answer in the database' do
          expect { post :create, params: @params }.to change(Answer, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: @params
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect { post :create, params: { question_id: question.id, answer: { body: nil } } }.to_not change(Answer, :count)
        end

        it 're-renders edit view' do
          post :create, params: { question_id: question.id, answer: { body: nil } }
          expect(response).to render_template :edit
        end
      end
    end

    describe 'by unauthenticated user' do
      it 'does not save a new answer in the database' do
        @params = { question_id: question.id, answer: { body: 'MyText' } }
        expect { post :create, params: @params }.not_to change(Answer, :count)
      end
    end
  end
end
