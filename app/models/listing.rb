class Listing < ApplicationRecord
  belongs_to :commodity
  belongs_to :selected_bid, optional: true, class_name: "Bid"

  has_many :bids

  validates_presence_of :status, :quote_price_per_month, :selection_strategy
  validate :ensure_correct_logged_in_lender
  validate :ensure_only_1_active_listing
  validate :ensure_no_rented_listing
  validate :ensure_valid_selected_bid

  attr_readonly :commodity

  before_validation :set_status_to_active, on: :create

  enum status: {
    active: "active",
    rented: "rented",
    closed: "closed"
  }

  enum selection_strategy: {
    highest_offered_amount: "highest_offered_amount",
    highest_overall_price: "highest_overall_price"
  }

  def expire_listing!
    @is_expiring = true
    bid = matching_bid
    if bid.present?
      update!({ selected_bid: bid }.merge(status: Listing.statuses[:rented]))
    else
      closed!
    end
  end

  def expire_rental!
    @is_expiring = true
    closed!
  end

  private

  def ensure_correct_logged_in_lender
    if !@is_expiring && commodity.user.id != Current.user&.id
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.incorrect_logged_in_lender"))
    end
  end

  def ensure_only_1_active_listing
    if active? && commodity.listings.where.not(id: id).active.count.positive?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.only_1_active_listing"))
    end
  end

  def ensure_no_rented_listing
    if (active? || rented?) && commodity.listings.where.not(id: id).rented.count.positive?
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.no_rented_listing"))
    end
  end

  def ensure_valid_selected_bid
    if selected_bid.present? && selected_bid.price_per_month < quote_price_per_month
      errors.add(:base, I18n.t("custom.activerecord.errors.listing.selected_bid_price_must_be_higher_than_quoted"))
    end
  end

  def matching_bid
    case selection_strategy
    when Listing.selection_strategies[:highest_offered_amount] then find_highest_priced_bid
    when Listing.selection_strategies[:highest_overall_price] then find_highest_valued_bid
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
