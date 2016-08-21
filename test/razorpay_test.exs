defmodule RazorpayTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    Application.ensure_all_started :hackney
  end

  test "sample request" do
    use_cassette "sample_request", match_requests_on: [:request_body] do
      res = Razorpay.make_test_request
      assert res["message"] == "Welcome to Razorpay API."
    end
  end
end
