class Lenders::CommoditiesController < Lenders::BaseController
  def index
    render_successfully({ commodities: Current.user.commodities }, :ok)
  end

  def new
    render_successfully({ categories: Commodity.categories.values }, :ok)
  end

  def create
    commodity = Commodity.new(commodity_params.merge(user: Current.user))
    if commodity.save
      render_successfully({ message: I18n.t("shared.created_successfully", resource: "Commodity"), commodity: commodity }, :created)
    else
      respond_with_error(commodity.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def commodity_params
    params.require(:commodity).permit(:name, :description, :category)
  end
end
