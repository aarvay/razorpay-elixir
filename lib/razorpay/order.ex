defmodule Razorpay.Order do
  import Razorpay

  @derive {Poison.Encoder, except: [:entity]}

  defstruct [:id, :amount, :currency, :attempts, :status, :receipt, :notes,
             :created_at]

  @type t :: %__MODULE__{id: binary, amount: integer, currency: binary,
  attempts: integer, status: binary, receipt: binary, notes: map,
  created_at: binary}

  @endpoint "/orders"

  @spec all(Keyword.t) :: {:ok, Razorpay.Collection.t(t)} | Razorpay.Error.type
  def all(opts \\ []) do
    request(:get, @endpoint, opts)
    |> process_response(%Razorpay.Collection{items: [%__MODULE__{}]})
  end

  @spec get(binary, Keyword.t) :: {:ok, t} | Razorpay.Error.type
  def get(id, opts \\ []) do
    request(:get, "#{@endpoint}/#{id}", opts)
    |> process_response(%__MODULE__{})
  end

  @spec create(Keyword.t) :: {:ok, t} | Razorpay.Error.type
  def create(opts \\ []) do
    request(:post, @endpoint, opts)
    |> process_response(%__MODULE__{})
  end

  def payments(id, opts \\ [])

  @spec payments(binary, Keyword.t) :: {:ok, Razorpay.Collection.t(Razorpay.Payment.t)} | Razorpay.Error.type
  def payments(id, opts) when is_binary(id) do
    request(:get, "#{@endpoint}/#{id}/payments", opts)
    |> process_response(%Razorpay.Collection{items: [%Razorpay.Payment{}]})
  end

  @spec payments(t, Keyword.t) :: {:ok, Razorpay.Collection.t(Razorpay.Payment.t)} | Razorpay.Error.type
  def payments(order, opts) when is_map(order) do
    id = order.id
    request(:get, "#{@endpoint}/#{id}/payments", opts)
    |> process_response(%Razorpay.Collection{items: [%Razorpay.Payment{}]})
  end
end
