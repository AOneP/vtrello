class LocalesController < ApplicationController
  skip_before_action :set_locale

  def show
    cookies['locale'] = params[:locale]
    redirect_to root_path, notice: I18n.t('locales.show')
  end

end
