require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }

  describe 'GET #show' do
    let(:answer) { question.answers.create(body: 'MyText') }
    before { get :show, params: { question_id: question, id: answer } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'POST #create' do
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
end
