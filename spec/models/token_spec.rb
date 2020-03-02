require 'rails_helper'

describe Token do
  let(:value) { SecureRandom.uuid }

  subject {described_class.new}
  context '#token generated?' do
    context 'after saved in database' do
      before do
        allow(SecureRandom).to receive(:uuid) {'123'}
      end
      it 'generates token value' do
        expect { subject.save }.to change { subject.value }.from(nil).to('123')
      end
    end
  end
end
