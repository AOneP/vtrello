require 'rails_helper'

describe CreateBoardForm do

  let(:user) { create(:user)}
  let(:board) { create(:board, owner_id: user.id) }
  let(:title) { board.title }
  let(:describe) { board.describe }
  let(:background_color) { board.background_color }

  let(:params) do
    {
      title: title,
      describe: describe,
      background_color: background_color,
      current_user: user
    }
  end

  let(:form) { described_class.new(params)}

  context 'when provided valid attributes' do

    it 'returnes true' do
      expect(form.save).to eq(true)
    end
  end
end
