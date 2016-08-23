defmodule Razorpay.Error do
  defexception [:code, :description, :field]

  @type t :: %__MODULE__{code: binary, description: binary, field: binary}
  @type type :: {:error, t}

  def message(%{code: code, description: desc, field: field}) do
    code =
      code
      |> String.downcase
      |> Macro.camelize
      message = "#{code}: #{desc}"
      if field, do: message <> "in the field: \"#{field}\"", else: message
  end

  def exception(message) do
    %__MODULE__{description: message}
  end
end
