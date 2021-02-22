require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'GET #show' do
    let(:answer) { question.answers.create(body: 'MyText', user: user) }
    before { get :show, params: { id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
    describe 'by authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:params) { { question_id: question.id, answer: { body: 'MyText' } } }

        it 'saves a new answer in the database' do
          expect { post :create, params: params }.to change(question.answers, :count).by(1)
        end

        it 'redirects to question#show view' do
          post :create, params: params
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        let(:params) { { question_id: question.id, answer: { body: nil } } }

        it 'does not save the answer' do
          expect { post :create, params: params }.to_not change(Answer, :count)
        end

        it 're-renders edit view' do
          post :create, params: params
          expect(response).to redirect_to question
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

  describe 'DELETE #destroy' do
    before { login(user) }

    describe 'Owner of the answer' do
      let!(:answer) { create(:answer, user: user, question: question) }
      let(:params) { { id: answer, question_id: question } }

      it 'deletes the answer' do
        expect { delete :destroy, params: params }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question#show' do
        delete :destroy, params: params
        expect(response).to redirect_to question
      end
    end

    describe 'Not owner of the answer' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, user: another_user, question: question) }

      it 'can not delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.not_to change(Answer, :count)
      end
    end
  end
end
