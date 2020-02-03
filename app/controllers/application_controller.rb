class ApplicationController < ActionController::Base

  before_action :set_locale

  private

  def set_locale
    cookies['locale'] = I18n.default_locale.to_s if cookies['locale'].nil?
    I18n.locale = cookies['locale'].to_sym
  end

end
