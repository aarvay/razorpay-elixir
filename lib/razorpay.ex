defmodule Razorpay do

  @base_url "https://api.razorpay.com/v1"
  @test_url "https://api.razorpay.com"
  @client_vsn Mix.Project.config[:version]

  def make_test_request do
    request
  end

  defp req_headers do
    [{"User-Agent", "Razorpay-Elixir/#{@client_vsn}"}]
  end

  defp auth do
    key_id =
      Application.get_env(:razorpay, :key_id)
      || System.get_env "RAZORPAY_KEY_ID"
    key_secret =
      Application.get_env(:razorpay, :key_secret)
      || System.get_env "RAZORPAY_KEY_SECRET"

    {key_id, key_secret}
  end

  defp request(method \\ :get, endpoint \\ "/", body \\ "") do
    url = process_url(endpoint)
    {:ok, _status, _, client_ref} =
      :hackney.request(method, url, req_headers, body, [basic_auth: auth])

    process_response(client_ref)
  end

  defp process_url("/") do
    @test_url
  end

  defp process_url(endpoint) do
    @base_url <> endpoint
  end

  defp process_response(client_ref) do
    case :hackney.body(client_ref) do
      {:ok, res} ->
        case Poison.decode(res) do
          {:ok, result} ->
            result
          {:error, _} -> "Got an invalid JSON response from Razorpay"
        end
      {:error, reason} ->
        reason
    end
  end
end
