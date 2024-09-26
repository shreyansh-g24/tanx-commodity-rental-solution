class Renters::BidsController < Renters::BaseController
  before_action :load_bid, only: %i[update]

  def index
    render_successfully({ bids: Current.user.bids }, :ok)
  end

  def create
    bid = Bid.new(bid_create_params)
    if bid.save
      render_successfully({ message: I18n.t("shared.created_successfully", resource: "Bid"), bid: bid }, :created)
    else
      respond_with_error(bid.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    if @bid.update(bid_update_params)
      render_successfully({ message: I18n.t("shared.updated_successfully", resource: "Bid"), bid: @bid }, :ok)
    else
      respond_with_error(@bid.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def bid_create_params
    params.require(:bid).permit(:listing_id, :price_per_month, :number_of_months)
  end

  def bid_update_params
    params.require(:bid).permit(:price_per_month, :number_of_months)
  end

  def load_bid
    @bid = Bid.find_by(id: params[:id])
    unless @bid.present?
      respond_with_error([ I18n.t("shared.not_found", resource: "Bid") ], :not_found)
    end
  end
end
