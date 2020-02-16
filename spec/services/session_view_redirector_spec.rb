require 'rails_helper'

describe SessionViewRedirector do

  let(:board) { create(:board, owner: create(:user)) }
  let(:current_user) { create(:user) }
  let(:service) { described_class.new(current_user, assigner_code) }
  let(:assigner_code) { nil }

  shared_examples_for 'returnes_redirect_path' do
    it 'returnes boards_path' do
      expect(service.redirect_path).to eq(Rails.application.routes.url_helpers.boards_path)
    end
  end

  shared_examples_for 'for_should_be_redirected' do |boolean|
    it "returnes #{boolean} for #should_be_redirected?" do
      expect(service.should_be_redirected?).to eq(boolean)
    end
  end

  shared_examples_for 'returnes_message' do |message_type, message_value|
    it "returnes message #{message_type}" do
      expect(service.message).to eq(message_value)
    end
  end

  context 'when user logged in with token' do

    let(:assigner_code) { :success }

    it_behaves_like 'for_should_be_redirected', true

    it_behaves_like 'returnes_redirect_path'

    it_behaves_like 'returnes_message', :success, { notice: I18n.t('member_invitation.notifications.success') }
  end

  context 'when user logged in without token' do

    it_behaves_like 'for_should_be_redirected', true

    it_behaves_like 'returnes_redirect_path'

    it_behaves_like 'returnes_message', :already_logged, { notice: I18n.t('session.notifications.already_logged') }
  end

  context 'when user logged with invalid token' do
    context 'unknown' do
      let(:assigner_code) { :unknown }

      it_behaves_like 'for_should_be_redirected', true

      it_behaves_like 'returnes_redirect_path'

      it_behaves_like 'returnes_message', :unknown, { alert: I18n.t('application.notifications.board_invitations.unknown') }
    end

    context 'expired' do
      let(:assigner_code) { :expired }

      it_behaves_like 'for_should_be_redirected', true

      it_behaves_like 'returnes_redirect_path'

      it_behaves_like 'returnes_message', :expired, { alert: I18n.t('application.notifications.board_invitations.expired') }

    end

    context 'used' do
      let(:assigner_code) { :used }

      it_behaves_like 'for_should_be_redirected', true

      it_behaves_like 'returnes_redirect_path'

      it_behaves_like 'returnes_message', :used, { alert: I18n.t('application.notifications.board_invitations.used') }
    end

  end

  context 'when user is not logged in' do

    let(:current_user) { nil }

    it_behaves_like 'for_should_be_redirected', false

    it 'returnes nil' do
      expect(service.redirect_path).to eq(nil)
    end
  end
end
