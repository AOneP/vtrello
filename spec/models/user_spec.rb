require 'rails_helper'

describe User do
  let(:confirmed_at) { Time.now }

  subject {described_class.new(confirmed_at: confirmed_at)}
  context '#confirmed?' do
    context 'when confirmed_at is set' do
      it 'returnes true' do
        expect(subject.confirmed?).to eq(true)
      end
    end

    context 'when confirmed_at is not set' do
      let(:confirmed_at) { nil }
      it 'returnes false' do
        expect(subject.confirmed?).to eq(false)
      end
    end
  end
end
