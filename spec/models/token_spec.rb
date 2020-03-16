require 'rails_helper'

describe Token do
  let(:value) { '123' }

  context '#token generated?' do
    context 'after saved in database' do
      before do
        allow(SecureRandom).to receive(:uuid) {value}
        create(:token_invitation, target_id: 1)
      end
      it 'generates token value' do
        expect(Token.last.value).to eq(value)
      end
    end
  end
end
