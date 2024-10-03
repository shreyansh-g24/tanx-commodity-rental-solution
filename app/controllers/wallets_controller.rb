class WalletsController < ApplicationController
  before_action :load_wallet
  before_action :ensure_enough_balance, only: :withdrawal

  def deposit
    if @wallet.update balance: @wallet.balance + wallet_params[:amount]
      render_successfully({ message: I18n.t("wallets.deposit.deposit_successful") }, :ok)
    else
      respond_with_error(@wallet.errors.full_messages, :unprocessable_entity)
    end
  end

  def withdrawal
    if @wallet.update(balance: @wallet.balance - wallet_params[:amount])
      render_successfully({ message: I18n.t("wallets.withdrawal.withdrawal_successful") }, :ok)
    else
      respond_with_error(@wallet.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def wallet_params
    params.require(:payload).permit(:amount, :currency)
  end

  def load_wallet
    @wallet = Current.user.wallets.find_or_create_by(cryptocurrency: wallet_params[:currency], balance: 0)
  end

  def ensure_enough_balance
    unless @wallet.balance >= wallet_params[:amount]
      respond_with_error([ I18n.t("wallets.withdrawal.not_enough_balance") ], :unprocessable_entity)
    end
  end
end
