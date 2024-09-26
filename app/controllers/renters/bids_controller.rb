class Renters::BidsController < Renters::BaseController
  def create
    bid = Bid.new(bid_params)
    if bid.save
      render_successfully({ message: I18n.t("renters.bids.create.message"), bid: bid }, :created)
    else
      respond_with_error(bid.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:listing_id, :price_per_month, :number_of_months)
  end
end
