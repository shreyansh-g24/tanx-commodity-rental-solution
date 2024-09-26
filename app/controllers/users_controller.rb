class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new create login]

  def new
    user_types = User.user_types.values
    render_successfully({ user_types: user_types }, :ok)
  end

  def create
    user = User.new(user_params)
    if user.save
      render_successfully({ user: user, message: I18n.t("users.create.message") }, :created)
    else
      respond_with_error(user.errors.full_messages, :unprocessable_entity)
    end
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user.nil?
      respond_with_error([ I18n.t("users.login.email_not_found") ], :unauthorized)
    elsif user.password != login_params[:password]
      respond_with_error([ I18n.t("users.login.incorrect_password") ], :unauthorized)
    else
      user.generate_jwt_token
      render_successfully({ user: user, message: I18n.t("users.login.message") }, :ok)
    end
  end

  def logout
    Current.user.reset_jwt_token
    render_successfully({ message: I18n.t("users.logout.message") }, :ok)
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_type, :password, :password_confirmation)
  end

  def login_params
    params.require(:login).permit(:email, :password)
  end
end
