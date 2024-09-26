class ApplicationController < ActionController::API
  before_action :authenticate_user!

  def respond_with_error(errors, status)
    render "shared/_errors", locals: { errors: errors }, status: status
  end

  def render_successfully(locals, status)
    render locals: locals, status: status
  end

  private

  def authenticate_user!
    Current.user = User.find_by(jwt_token: request.headers["X-AUTH-TOKEN"])
    if Current.user.nil?
      respond_with_error([ I18n.t("application.authentication_error") ], :unauthorized)
    end
  end
end
