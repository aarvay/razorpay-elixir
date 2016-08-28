defmodule Razorpay.Payment do
  import Razorpay

  @derive {Poison.Encoder, except: [:entity]}

  defstruct [:id, :amount, :currency, :status, :method, :description,
  :refund_status, :amount_refunded, :email, :contact, :fee, :service_tax,
  :error_code, :error_description, :notes, :order_id, :created_at]

  @type t :: %__MODULE__{id: binary, amount: integer, currency: binary,
  status: binary, method: binary, description: binary, refund_status: binary,
  amount_refunded: integer, email: binary, contact: binary, fee: integer,
  service_tax: integer, error_code: binary, error_description: binary,
  notes: map, created_at: binary}

  @endpoint "/payments"

  @spec all(Keyword.t) :: {:ok, Razorpay.Collection.t(t)} | Razorpay.Error.type
  def all(opts \\ []) do
    request(:get, @endpoint, opts)
    |> process_response(%Razorpay.Collection{items: [%__MODULE__{}]})
  end

  @spec get(binary, Keyword.t) :: {:ok, t} | Razorpay.error
  def get(id, opts \\ []) do
    request(:get, "#{@endpoint}/#{id}", opts)
    |> process_response(%__MODULE__{})
  end

  def capture(id, amount, opts \\ [])

  @spec capture(binary, integer, Keyword.t) :: {:ok, t} | Razorpay.Error.type
  def capture(id, amount, opts) when is_binary(id) do
    opts = [{:amount, amount} | opts]
    request(:post, "#{@endpoint}/#{id}/capture", opts)
    |> process_response(%__MODULE__{})
  end

  @spec capture(t, integer, Keyword.t) :: {:ok, t} | Razorpay.Error.type
  def capture(payment, amount, opts) when is_map(payment) do
    id = payment.id
    opts = [{:amount, amount} | opts]
    request(:post, "#{@endpoint}/#{id}/capture", opts)
    |> process_response(%__MODULE__{})
  end

  def refund(id, amount \\ nil, opts \\ [])

  @spec refund(binary, integer, Keyword.t) :: {:ok, Razorpay.Refund.t} | Razorpay.Error.type
  def refund(id, amount, opts) when is_binary(id) do
    opts = if amount, do: [{:amount, amount} | opts], else: opts
    request(:post, "#{@endpoint}/#{id}/refund", opts)
    |> process_response(%Razorpay.Refund{})
  end

  @spec refund(t, integer, Keyword.t) :: {:ok, Razorpay.Refund.t} | Razorpay.Error.type
  def refund(payment, amount, opts) when is_map(payment) do
    id = payment.id
    opts = if amount, do: [{:amount, amount} | opts], else: opts
    request(:post, "#{@endpoint}/#{id}/refund", opts)
    |> process_response(%Razorpay.Refund{})
  end

  def refunds(id, opts \\ [])

  @spec refunds(binary, Keyword.t) :: {:ok, Razorpay.Collection.t(Razorpay.Refund.t)} | Razorpay.Error.type
  def refunds(id, opts) when is_binary(id) do
    request(:get, "#{@endpoint}/#{id}/refunds", opts)
    |> process_response(%Razorpay.Collection{items: [%Razorpay.Refund{}]})
  end

  @spec refunds(t, Keyword.t) :: {:ok, Razorpay.Collection.t(Razorpay.Refund.t)} | Razorpay.Error.type
  def refunds(payment, opts) when is_map(payment) do
    id = payment.id
    request(:get, "#{@endpoint}/#{id}/refunds", opts)
    |> process_response(%Razorpay.Collection{items: [%Razorpay.Refund{}]})
  end

  def get_refund(payment_id, refund_id, opts \\ [])

  @spec get_refund(binary, binary, Keyword.t) :: {:ok, Razorpay.Refund.t} | Razorpay.Error.type
  def get_refund(id, refund_id, opts) when is_binary(id) do
    request(:get, "#{@endpoint}/#{id}/refunds/#{refund_id}", opts)
    |> process_response(%Razorpay.Refund{})
  end

  @spec get_refund(t, binary, Keyword.t) :: {:ok, Razorpay.Refund.t} | Razorpay.Error.type
  def get_refund(payment, refund_id, opts) when is_map(payment) do
    id = payment.id
    request(:get, "#{@endpoint}/#{id}/refunds/#{refund_id}", opts)
    |> process_response(%Razorpay.Refund{})
  end
end
