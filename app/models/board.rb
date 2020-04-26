class Board < ApplicationRecord

  before_destroy :destroy_tokens

  has_many :lists, dependent: :destroy
  has_many :members, dependent: :destroy
  belongs_to :owner, class_name: 'User', foreign_key: :owner_id

  enum background_color: { red: 0, blue: 10, black: 20 }

  def mapped_background_color
    { red: 'rgba(189, 68, 61, 0.9)', blue: 'rgba(55, 92, 200, 0.9)', black: 'rgba(50, 50, 50, 0.9)' }[background_color.to_sym]
  end
  
  private

  def destroy_tokens
    Token.where(type: ['Token::Invitation'], target_id: id).destroy_all
  end
end
