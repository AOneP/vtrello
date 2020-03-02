# frozen_string_literal: true
module ControllerHelpers
  def sign_in(user = nil)
    user ||= FactoryBot.build(:user, id: 1)
    allow(controller).to receive(:current_user).and_return(user)
  end
end
