class Bid < ApplicationRecord
  belongs_to :user
  belongs_to :listing

  validates_uniqueness_of :listing, scope: :user
  validates_presence_of :price_per_month, :number_of_months
  validate :ensure_user_is_a_lender
  validate :ensure_listing_is_active
  validate :ensure_minimum_price_per_month
  validate :ensure_current_user_is_bidder, on: :update

  attr_readonly :user, :listing

  before_validation :set_user, on: :create

  private

  def ensure_user_is_a_lender
    unless user.renter?
      errors.add(:base, I18n.t("custom.activerecord.errors.bid.user_must_be_renter"))
    end
  end

  def ensure_listing_is_active
    unless listing.active?
      errors.add(:base, I18n.t("custom.activerecord.errors.bid.listing_must_be_active"))
    end
  end

  def ensure_minimum_price_per_month
    unless price_per_month >= listing.quote_price_per_month
      errors.add(:base, I18n.t("custom.activerecord.errors.bid.must_be_gteq_quote_price"))
    end
  end

  def ensure_current_user_is_bidder
    unless Current.user.id == Bid.find(id).user_id
      errors.add(:base, I18n.t("custom.activerecord.errors.bid.current_user_must_be_bidder"))
    end
  end

  def set_user
    self.user = Current.user
  end
end
