require 'rails_helper'

describe V1::Form::ResponsesController do
  describe 'DELETE /form/responses/:id', version: 1 do
    let(:form) { FactoryBot.create(:form) }

    let(:record) { FactoryBot.create(:response, form: form) }
    let(:record_url) { "/v1/form/responses/#{record.id}" }
    let(:record_permission) { 'form/response.destroy' }

    let(:open_question) { FactoryBot.create(:open_question, form: form) }
    let(:closed_question) { FactoryBot.create(:closed_question, form: form) }
    let(:closed_question_option) do
      FactoryBot.create(:closed_question_option, question: closed_question)
    end

    before do
      open_question
      closed_question
      closed_question_option
    end

    it_behaves_like 'a destroyable and permissible model'

    context 'when destroy without permission' do
      subject(:request) { delete(record_url) }

      include_context 'when authenticated' do
        let(:user) { FactoryBot.create(:user, user_permission_list: []) }
      end
      let(:record) { FactoryBot.create(:response, form: form, user: user) }

      it_behaves_like '204 No Content'
      it { expect { request }.to(change { record.class.count }.by(-1)) }

      context 'when destroy someone elses record' do
        let(:another_user) { FactoryBot.create(:user, user_permission_list: []) }
        let(:record) { FactoryBot.create(:response, form: form, user: another_user) }

        it_behaves_like '403 Forbidden'
      end
    end
  end
end
