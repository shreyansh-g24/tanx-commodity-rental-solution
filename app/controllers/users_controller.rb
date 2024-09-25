class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created
    else
      respond_with_error(@user.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :user_type, :password, :password_confirmation)
  end
end
