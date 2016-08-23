defmodule RazorpayTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import Mock

  setup_all do
    Application.ensure_all_started :hackney
  end

  test "sample request works" do
    use_cassette "sample_request" do
      {:ok, res} = Razorpay.make_test_request
      assert res.message == "Welcome to Razorpay API."
    end
  end

  test "sample request fails when basic auth details are not provided" do
    with_mock System, [get_env: fn(_opts) -> nil end] do
      assert_raise Razorpay.Error, fn ->
        Razorpay.make_test_request
      end
    end
  end

  test "Error is returned for status other than 200" do
    use_cassette "bad_request" do
      {:error, err} =
        Razorpay.request(:get, "/invalid_endpoint")
        |> Razorpay.process_response
      assert err.__struct__ == Razorpay.Error
      assert err.code == "BAD_REQUEST_ERROR"
      assert err.description == "The requested URL was not found on the server."
    end
  end
end
