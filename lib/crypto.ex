defmodule Crypto do
  def hexdigest(key, data) do
    :sha256
      |> :crypto.hmac(key, data)
      |> Base.encode16(case: :lower)
  end
end
