defmodule Razorpay do
  @base_url "https://api.razorpay.com/v1"
  @test_url "https://api.razorpay.com"
  @client_vsn Mix.Project.config[:version]

  def request(method, endpoint \\ "/", opts \\ [])

  def request(:get, endpoint, opts) do
    url = process_url(endpoint)
    url = if opts !== [], do: url <> "?" <> URI.encode_query(opts), else: url
    :hackney.request(:get, url, req_headers, "", [basic_auth: auth])
  end

  def request(:post, endpoint, opts) do
    url = process_url(endpoint)
    :hackney.request(:post, url, req_headers, {:form, opts},
      [basic_auth: auth])
  end

  def process_response({:ok, status, _, client_ref}, as \\ nil) do
    {:ok, res} = :hackney.body(client_ref)
    case status do
      200 ->
        Poison.decode(res, keys: :atoms, as: as)
      c when c in [400, 401, 500, 502, 504] ->
        res =
          Poison.decode!(res, keys: :atoms!,
            as: %{error: %Razorpay.Error{}})
        {:error, res.error}
    end
  end

  def make_test_request do
    request(:get)
    |> process_response
  end

  defp req_headers do
    [{"User-Agent", "Razorpay-Elixir/#{@client_vsn}"}]
  end

  defp key_id do
    value =
      (Application.get_env(:razorpay, :key_id)
      || System.get_env "RAZORPAY_KEY_ID")
    if value, do: value, else: raise Razorpay.Error,
      "Razorpay key_id or key_secret is missing"
  end

  defp key_secret do
    value =
      (Application.get_env(:razorpay, :key_secret)
      || System.get_env "RAZORPAY_KEY_SECRET")
    if value, do: value, else: raise Razorpay.Error,
      "Razorpay key_id or key_secret is missing"
  end

  defp auth do
    {key_id, key_secret}
  end

  defp process_url("/") do
    @test_url
  end

  defp process_url(endpoint) do
    @base_url <> endpoint
  end
end
