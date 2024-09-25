class ApplicationController < ActionController::API
  def respond_with_error(errors, status)
    @errors = errors
    render "shared/_errors", status: status
  end
end
