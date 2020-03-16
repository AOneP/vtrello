class TokenInvitationUserAssigner

  attr_reader :code

  INVALID_CODES = [ :used, :unknown, :expired, :invalid_current_user ]

  def initialize(token_value, user)
    @token = Token::Invitation.find_by(value: token_value)
    @user = user
    @code = nil
  end

  def assign
    return false unless valid?
    ActiveRecord::Base.transaction { call }
    @code = :success
    true
  rescue => e
    @code = :unknown
    false
    # ie. rollbar in future
  end

  def success?
    # return assign if @code.nil?
    @code == :success
  end

  def called?
    !@code.nil?
  end

  def valid?
    return false if (token.blank? || user.blank?)

    @code = :invalid_current_user if (token.present? && token.email != user.email)
    @code = :used if token&.used?
    @code = :expired if token.present? && !token.used? && token.expired?

    !INVALID_CODES.include?(@code)
  end

  private

  attr_reader :token, :user

  def call
    Member.create!(board: token.target, user: user)
    token.update!(used: true)
  end
end
