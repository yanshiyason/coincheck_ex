defmodule CoincheckEx.HTTP do
  @moduledoc false
  @base_url "https://coincheck.jp/"
  @base_headers ["Content-Type": "application/json"]

  def get(endpoint, params \\ %{}) do
    uri = @base_url <> endpoint

    request = HTTPoison.request(:get, uri, body_from(params), headers(uri, body_from(params)))
    request
      |> handle_response
  end

  def post(endpoint, params \\ %{}) do
    uri = @base_url <> endpoint
    body = body_from(params)
    uri
      |> HTTPoison.post(body, uri |> headers(body))
      |> handle_response
  end

  def delete(endpoint) do
    uri = @base_url <> endpoint

    uri
      |> HTTPoison.delete(uri |> headers)
      |> handle_response
  end

  def headers(uri \\ "", body \\ "") do
    nonce = calculate_nonce
    [
      "ACCESS-KEY": CoincheckEx.api_key,
      "ACCESS-NONCE": nonce,
      "ACCESS-SIGNATURE": signature(nonce, uri, body)
    ] |> Keyword.merge(@base_headers)
  end

  defp body_from(params \\ %{}) do
    case map_size(params) do
      0 -> ""
      _ ->
        {:ok, body} = Poison.encode(params)
        body
    end
  end

  defp calculate_nonce do
    DateTime.utc_now
      |> DateTime.to_unix(:microseconds)
      |> Integer.to_string
  end

  defp signature(nonce \\ "", uri \\ "", body \\ "") do
    message = [nonce, uri, body] |> Enum.join

    Crypto.hexdigest(CoincheckEx.secret_key, message)
  end

  defp handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: status_code} = response} when status_code in 200..299 ->
        {:ok, Poison.decode!(response.body)}

      {:ok, %HTTPoison.Response{status_code: status_code} = response} when status_code in 400..599 ->
        {:error, Poison.decode!(response.body)}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{reason: reason}}
    end
  end
end
