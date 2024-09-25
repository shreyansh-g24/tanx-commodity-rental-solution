class ApplicationController < ActionController::API
  def respond_with_error(errors, status)
    render "shared/_errors", locals: { errors: errors }, status: status
  end
end
