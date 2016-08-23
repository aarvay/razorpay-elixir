defmodule Razorpay.PaymentTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    Application.ensure_all_started :hackney
  end

  test "all payments" do
    use_cassette "payment/all_payments" do
      {:ok, payments} = Razorpay.Payment.all
      assert payments.__struct__ == Razorpay.Collection
    end
  end

  test "all payments with opts" do
    use_cassette "payment/all_payments_with_opts" do
      opts = [count: 1]
      {:ok, payments} = Razorpay.Payment.all(opts)
      assert payments.__struct__ == Razorpay.Collection
      assert Enum.count(payments.items) == 1
    end
  end

  test "get payment by id" do
    use_cassette "payment/payment_by_id" do
      {:ok, all} = Razorpay.Payment.all
      [first|_] = all.items
      {:ok, payment} = Razorpay.Payment.get first.id
      assert payment.__struct__ == Razorpay.Payment
      assert payment.id == first.id
    end
  end

  test "capture payment by id" do
    use_cassette "payment/capture_payment", custom: true do
      {:ok, payment} = Razorpay.Payment.capture "fake_payment_id", 5000
      assert payment.__struct__ == Razorpay.Payment
      assert payment.status == "captured"
    end
  end

  test "full refund" do
    use_cassette "payment/full_refund", custom: true do
      {:ok, refund} = Razorpay.Payment.refund "fake_payment_id"
      assert refund.__struct__ == Razorpay.Refund
      assert refund.payment_id == "fake_payment_id"
      assert refund.amount == 5000
    end
  end

  test "partial refund" do
    use_cassette "payment/partial_refund", custom: true do
      {:ok, refund} = Razorpay.Payment.refund "fake_payment_id", 2000
      assert refund.__struct__ == Razorpay.Refund
      assert refund.payment_id == "fake_payment_id"
      assert refund.amount == 2000
    end
  end

  test "all refunds" do
    use_cassette "payment/all_refunds", custom: true do
      {:ok, refunds} = Razorpay.Payment.refunds "fake_payment_id"
      assert refunds.__struct__ == Razorpay.Collection
    end
  end

  # TODO: The docs has it, but doesn't work. Contact Razorpay
  # test "all refunds with opts" do
  #   use_cassette "payment/all_refunds_with_opts", custom: true do
  #     opts = [count: 1]
  #     {:ok, refunds} = Razorpay.Payment.refunds("fake_payment_id", opts)
  #     assert refunds.__struct__ == Razorpay.Collection
  #     assert Enum.count(refunds.items) == 1
  #   end
  # end
end
