class Commodity < ApplicationRecord
  belongs_to :user

  has_many :listings

  validates_presence_of :name, :category
  validate :ensure_user_is_a_lender

  attr_readonly :user

  before_validation :set_user, on: :create

  enum category: {
    electronic_appliance: "electronic_appliance",
    electronic_accessory: "electronic_accessory",
    furniture: "furniture",
    men_wear: "men_wear",
    women_wear: "women_wear",
    shoes: "shoes"
  }

  private

  def ensure_user_is_a_lender
    unless user.lender?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.commodity.user_must_be_lender"))
    end
  end

  def set_user
    self.user = Current.user
  end
end
