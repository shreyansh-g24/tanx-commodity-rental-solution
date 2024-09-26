class Lenders::CommoditiesController < Lenders::BaseController
  def index
    render locals: { commodities: @user.commodities }, status: :ok
  end

  def new
    render locals: { categories: Commodity.categories.values }, status: :ok
  end

  def create
    commodity = Commodity.new(commodity_params.merge(user: @user))
    if commodity.save
      render locals: { message: I18n.t("lenders.commodities.create.message"), commodity: commodity }, status: :created
    else
      respond_with_error(commodity.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def commodity_params
    params.require(:commodity).permit(:name, :description, :category)
  end
end
