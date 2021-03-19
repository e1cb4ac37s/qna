require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }

  describe 'DELETE #destroy' do
    before { login(user) }
    let(:files) { [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")] }

    describe 'Owner of the answer' do
      let!(:answer) { create(:answer, user: user, question: question, files: files) }

      it 'deletes attachment' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: answer.files.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    describe 'Not owner of the answer' do
      let(:another_user) { create(:user) }
      let(:answer) { create(:answer, user: another_user, question: question, files: files) }

      it 'can not delete the answer' do
        expect { delete :destroy, params: { id: answer.files.first }, format: :js }.not_to change(answer.files, :count)
      end
    end
  end
end