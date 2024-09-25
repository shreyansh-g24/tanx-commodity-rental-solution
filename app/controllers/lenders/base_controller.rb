class Lenders::BaseController < ApplicationController
  before_action :ensure_lender_logged_in

  private

  def ensure_lender_logged_in
    unless @user.lender?
      respond_with_error([ I18n.t("lenders.authentication_error") ], :unauthorized)
    end
  end
end
