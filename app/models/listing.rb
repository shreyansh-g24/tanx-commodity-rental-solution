class Listing < ApplicationRecord
  belongs_to :commodity
  belongs_to :selected_bid, optional: true, class_name: "Bid"

  has_many :bids

  validates_presence_of :status, :quote_price_per_month, :selection_strategy
  validate :ensure_correct_logged_in_lender
  validate :ensure_only_1_active_listing
  validate :ensure_no_rented_listing
  validate :ensure_listing_is_active_on_update, on: :update
  validate :ensure_valid_selected_bid

  attr_readonly :commodity

  before_validation :set_status_to_active

  enum status: {
    active: "active",
    rented: "rented",
    closed: "closed"
  }

  enum selection_strategy: {
    highest_offered_amount: "highest_offered_amount",
    highest_overall_price: "highest_overall_price"
  }

  def expire!
    bid = matching_bid
    if bid.present?
      update!({ selected_bid: bid }.merge(status: Listing.statuses[:rented]))
    else
      closed!
    end
  end

  private

  def ensure_correct_logged_in_lender
    if commodity.user.id != Current.user.id || !Current.user.lender?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.incorrect_logged_in_lender"))
    end
  end

  def ensure_only_1_active_listing
    if active? && commodity.listings.active.count.positive?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.only_1_active_listing"))
    end
  end

  def ensure_no_rented_listing
    if (active? || rented?) && commodity.listings.rented.count.positive?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.no_rented_listing"))
    end
  end

  def ensure_listing_is_active_on_update
    unless active?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.must_be_active_for_update"))
    end
  end

  def ensure_valid_selected_bid
    if selected_bid.present? && selected_bid.price_per_month < quote_price_per_month
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.selected_bid_price_must_be_higher_than_quoted"))
    end
  end

  def matching_bid
    case selection_strategy
    when selection_strategies[:highest_offered_amount] then find_highest_priced_bid
    when selection_strategies[:highest_overall_price] then find_highest_valued_bid
    end
  end

  def find_highest_priced_bid
    bids.order("price_per_month DESC").first
  end

  def find_highest_valued_bid
    bids.select("*, (price_per_month * number_of_months) AS value").order("value DESC").first
  end

  def set_status_to_active
    self.status = Listing.statuses[:active]
  end
end
