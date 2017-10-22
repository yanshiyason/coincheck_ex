defmodule CoincheckEx do
  alias CoincheckEx.HTTP
  alias CoincheckEx.Currency

  use Application

  @doc """
  Starts the CoincheckEx client.
  """
  def start(_type, _args) do
    api_key    = Application.get_env(:coincheck_ex, :api_key   , System.get_env("COINCHECK_API_KEY"))
    secret_key = Application.get_env(:coincheck_ex, :secret_key, System.get_env("COINCHECK_SECRET_KEY"))

    secrets = %{
      api_key: api_key,
      secret_key: secret_key,
    }

    Agent.start_link(fn -> secrets end, name: __MODULE__)
  end

  # Get requests
  def read_balance do
    HTTP.get("api/accounts/balance")
  end

  def read_leverage_balance do
    HTTP.get("api/accounts/leverage_balance")
  end

  def read_accounts do
    HTTP.get("api/accounts")
  end

  def read_transactions do
    HTTP.get("api/exchange/orders/transactions")
  end

  def read_positions(body \\ %{}) do
    HTTP.get("api/exchange/leverage/positions")
  end

  def read_orders do
    HTTP.get("api/exchange/orders/opens")
  end

  def read_send_money(currency \\ Currency.btc) do
    params = %{currency: currency}
    HTTP.get("api/send_money", params)
  end

  def read_deposit_money(currency \\ Currency.btc) do
    params = %{currency: currency}
    HTTP.get("api/deposit_money", params)
  end

  def read_ticker do
    HTTP.get("api/ticker")
  end

  def read_trades do
    HTTP.get("api/trades")
  end

  def read_rate(pair \\ Currency.Pairs.btc_jpy) do
    HTTP.get("/api/rate/#{pair}")
  end

  def read_order_books do
    HTTP.get("api/order_books")
  end

  def read_bank_accounts do
    HTTP.get("api/bank_accounts")
  end

  def read_withdraws do
    HTTP.get("api/withdraws")
  end

  def read_borrows do
    HTTP.get("api/lending/borrows/matches")
  end

  # Post requests
  def create_orders(opts \\ []) do
    defaults = [
      order_type: nil,
      rate: nil,
      amount: nil,
      market_buy_amount: nil,
      position_id: nil,
      pair: Currency.Pairs.btc_jpy,
    ]
    params =
      defaults
        |> Keyword.merge(opts)
        |> Enum.into(%{})
    HTTP.post("api/exchange/orders", params)
  end

  def create_send_money(opts \\ []) do
    defaults = [
      address: nil,
      amount: nil
    ]
    params =
      defaults
        |> Keyword.merge(opts)
        |> Enum.into(%{})
    HTTP.post("api/send_money", params)
  end

  def create_bank_accounts(opts \\ []) do
    defaults = [
      bank_name: nil,
      branch_name: nil,
      bank_account_type: nil,
      number: nil,
      name: nil
    ]
    params =
      defaults
        |> Keyword.merge(opts)
        |> Enum.into(%{})
    HTTP.post("api/bank_accounts", params)
  end

  def create_borrows(opts \\ []) do
    defaults = [
      amount: nil,
      currency: nil,
    ]
    params =
        defaults
          |> Keyword.merge(opts)
          |> Enum.into(%{})
    HTTP.post("api/lending/borrows", params)
  end

  def repay_borrows(opts \\ []) do
    defaults = [id: nil]
    params =
        defaults
          |> Keyword.merge(opts)
          |> Enum.into(%{})
    HTTP.post("api/lending/borrows/#{params[:id]}/repay", params)
  end

  def transfer_to_leverage(opts \\ []) do
    defaults = [
      amount: nil,
      currency: Currency.JPY
    ]
    params =
      defaults
        |> Keyword.merge(opts)
        |> Enum.into(%{})
    HTTP.post("api/exchange/transfers/to_leverage", params)
  end

  def transfer_from_leverage(opts \\ []) do
    defaults = [
      amount: nil,
      currency: Currency.JPY
    ]
    params =
      defaults
        |> Keyword.merge(opts)
        |> Enum.into(%{})
    HTTP.post("api/exchange/transfers/from_leverage", params)
  end

  # Delete requests
  def delete_orders(id \\ nil) do
    HTTP.delete("api/exchange/orders/#{id}")
  end

  def delete_bank_accounts(id \\ nil) do
    HTTP.delete("api/bank_accounts/#{id}")
  end


  def delete_withdraws(id \\ nil) do
    HTTP.delete("api/withdraws/#{id}")
  end

  def create_deposit_money_fast(id \\ nil) do
    HTTP.delete("api/deposit_money/#{id}/fast")
  end

  # Secrets
  def api_key do
    Agent.get(__MODULE__, fn secrets -> secrets.api_key end)
  end

  def secret_key do
    Agent.get(__MODULE__, fn secrets -> secrets.secret_key end)
  end
end
