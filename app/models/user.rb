require "bcrypt"

class User < ApplicationRecord
  include BCrypt

  validates_presence_of :first_name, :last_name, :email, :user_type
  validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates_presence_of :password, :password_confirmation, on: :create
  validates :password, confirmation: true, on: :create

  enum user_type: {
    renter: "renter",
    lender: "lender"
  }

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def generate_jwt_token
    loop do
      token = SecureRandom.hex(32)

      if User.where(jwt_token: token).count.zero?
        update! jwt_token: token
        break
      end
    end
  end

  def reset_jwt_token
    update! jwt_token: nil
  end
end
