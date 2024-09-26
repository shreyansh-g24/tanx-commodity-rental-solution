class Lenders::ListingsController < Lenders::BaseController
  def new
    strategies = Listing.selection_strategies.values
    render_successfully({ selection_strategies: strategies }, :ok)
  end

  def create
    listing = Listing.new(listing_params)
    if listing.save
      render_successfully({ listing: listing, message: I18n.t("shared.created_successfully", resource: "Listing") }, :created)
    else
      respond_with_error(listing.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def listing_params
    params.require(:listing).permit(:commodity_id, :quote_price_per_month, :selection_strategy)
  end
end
