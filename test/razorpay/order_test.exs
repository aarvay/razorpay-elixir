defmodule Razorpay.OrderTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    Application.ensure_all_started :hackney
  end

  test "all orders" do
    use_cassette "order/all_orders" do
      {:ok, orders} = Razorpay.Order.all
      assert orders.__struct__ == Razorpay.Collection
    end
  end

  test "all orders with opts" do
    use_cassette "order/all_orders_with_opts" do
      opts = [count: 1]
      {:ok, orders} = Razorpay.Order.all(opts)
      assert orders.__struct__ == Razorpay.Collection
      assert Enum.count(orders.items) == 1
    end
  end

  test "get order by id" do
    use_cassette "order/order_by_id" do
      {:ok, all} = Razorpay.Order.all
      [first|_] = all.items
      {:ok, order} = Razorpay.Order.get(first.id)
      assert order.__struct__ == Razorpay.Order
      assert order.id == first.id
    end
  end

  test "create order" do
    use_cassette "order/create_order" do
      {:ok, order} =
        Razorpay.Order.create amount: 5000, currency: "INR", receipt: "TEST"
      assert order.__struct__ == Razorpay.Order
      assert order.amount == 5000
      assert order.currency == "INR"
      assert order.receipt == "TEST"
    end
  end

  test "all payments" do
    use_cassette "order/all_payments" do
      {:ok, all} = Razorpay.Order.all
      [first|_] = all.items
      {:ok, payments} = Razorpay.Order.payments(first.id)
      assert payments.__struct__ == Razorpay.Collection
    end
  end
end
