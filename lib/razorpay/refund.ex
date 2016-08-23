defmodule Razorpay.Refund do
  import Razorpay

  @derive [Poison.Encoder]

  defstruct [:id, :amount, :currency, :payment_id, :notes,
    :created_at]

  @type t :: %__MODULE__{id: binary, amount: integer, currency: binary,
    payment_id: binary, created_at: binary, notes: map}

  @endpoint "/refunds"

  @spec all(Keyword.t) :: {:ok, Razorpay.Collection.t(t)} | Razorpay.error
  def all(opts \\ []) do
    request(:get, @endpoint, opts)
    |> process_response(%Razorpay.Collection{items: [%__MODULE__{}]})
  end

  @spec get(binary, Keyword.t) :: {:ok, t} | Razorpay.error
  def get(id, opts \\ []) do
    request(:get, "#{@endpoint}/#{id}", opts)
    |> process_response(%__MODULE__{})
  end
end
