class Listing < ApplicationRecord
  belongs_to :commodity
  belongs_to :selected_bid, optional: true, class_name: "Bid"

  has_many :bids

  validates_presence_of :status, :quote_price_per_month, :selection_strategy
  validate :ensure_correct_logged_in_lender
  validate :ensure_only_1_active_listing
  validate :ensure_listing_is_active_on_update, on: :update

  enum status: {
    active: "active",
    rented: "rented",
    closed: "closed"
  }

  enum selection_strategy: {
    highest_offered_amount: "highest_offered_amount",
    highest_overall_price: "highest_overall_price"
  }

  def select_bid
    bid_id = case selection_strategy
    when selection_strategies[:highest_offered_amount] then find_highest_priced_bid
    when selection_strategies[:highest_overall_price] then find_highest_valued_bid
    end

    update! bid_id.merge(status: statuses[:rented])
  end

  private

  def ensure_correct_logged_in_lender
    if commodity.user.id != @user.id || !@user.lender?
      errors.add(I18n.t("custom.activerecord.errors.listing.incorrect_logged_in_lender"))
    end
  end

  def ensure_only_1_active_listing
    unless active? && commodity.listings.where(status: statuses[:active]).count.zero?
      errors.add(I18n.t("custom.activerecord.errors.listing.only_1_active_listing"))
    end
  end

  def ensure_listing_is_active_on_update
    unless active?
      errors.add(I18n.t("custom.activerecord.errors.listing.must_be_active_for_update"))
    end
  end

  def find_highest_priced_bid
    bids.order("price_per_month DESC").first.id
  end

  def find_highest_valued_bid
    bids.select("id, (price_per_month * number_of_months) AS value").order("value DESC").first.id
  end
end
