defmodule Razorpay.RefundTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    Application.ensure_all_started :hackney
  end

  test "all refunds" do
    use_cassette "refund/all_refunds" do
      {:ok, refunds} = Razorpay.Refund.all
      assert refunds.__struct__ == Razorpay.Collection
    end
  end

  test "all refunds with opts" do
    use_cassette "refund/all_refunds_with_opts" do
      opts = [count: 1]
      {:ok, refunds} = Razorpay.Refund.all opts
      assert refunds.__struct__ == Razorpay.Collection
      assert Enum.count(refunds.items) == 1
    end
  end

  test "get refund by id" do
    use_cassette "refund/refund_by_id" do
      {:ok, all} = Razorpay.Refund.all
      [first|_] = all.items
      {:ok, refund} = Razorpay.Refund.get first.id
      assert refund.__struct__ == Razorpay.Refund
      assert refund.id == first.id
    end
  end
end
