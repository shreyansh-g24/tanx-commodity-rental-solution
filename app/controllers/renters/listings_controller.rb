class Renters::ListingsController < Renters::BaseController
  def index
    render_successfully({ listings: Listing.active }, :ok)
  end
end
