require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'POST #create' do
    describe 'by authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        let(:params) { { question_id: question.id, answer: { body: 'MyText' } } }

        it 'saves a new answer in the database' do
          expect { post :create, params: params, format: :js }.to change(question.answers, :count).by(1)
        end

        it 'renders create' do
          post :create, params: params, format: :js
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        let(:params) { { question_id: question.id, answer: { body: nil } } }

        it 'does not save the answer' do
          expect { post :create, params: params, format: :js }.to_not change(Answer, :count)
        end

        it 'renders create' do
          post :create, params: params, format: :js
          expect(response).to render_template :create
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, user: user)}

    context 'with valid attributes' do
      before do
        login(user)
        patch :update, params: { id: answer, answer: { body: 'changed body' } }, format: :js
        answer.reload
      end

      it 'changes answer attributes' do
        expect(answer.body).to eq 'changed body'
      end

      it 'renders update view' do
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      before { login(user) }
      let(:params) { { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer attributes' do
        expect { patch :update, params: params, format: :js }.not_to change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: params, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    describe 'Owner of the answer' do
      let!(:answer) { create(:answer, user: user, question: question) }
      let(:params) { { id: answer, question_id: question } }

      it 'deletes the answer' do
        expect { delete :destroy, params: params, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: params, format: :js
        expect(response).to render_template :destroy
      end
    end

    describe 'Not owner of the answer' do
      let(:another_user) { create(:user) }
      let!(:answer) { create(:answer, user: another_user, question: question) }

      it 'can not delete the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.not_to change(Answer, :count)
      end
    end
  end
end
