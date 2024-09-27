class Renters::ListingsController < Renters::BaseController
  def index
    render_successfully({ listings: Listing.active.includes([ { selected_bid: :user }, { commodity: :user } ]) }, :ok)
  end
end
