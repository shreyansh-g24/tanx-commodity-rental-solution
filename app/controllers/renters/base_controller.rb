class Renters::BaseController < ApplicationController
  before_action :ensure_renter_logged_in

  private

  def ensure_renter_logged_in
    unless Current.user.renter?
      respond_with_error([ I18n.t("renters.authentication_error") ], :unauthorized)
    end
  end
end
