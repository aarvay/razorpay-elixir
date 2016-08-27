defmodule Razorpay.Collection do
  @derive {Poison.Encoder, except: [:entity]}

  defstruct [:count, :items]
  @type t(type) :: %__MODULE__{count: integer, items: [type]}
end
