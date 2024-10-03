class Wallet < ApplicationRecord
  belongs_to :user

  validates_presence_of :cryptocurrency, :balance
  validates_uniqueness_of :cryptocurrency, scope: :user_id
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
