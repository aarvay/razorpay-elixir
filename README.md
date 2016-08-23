# Razorpay Elixir

An elixir library for working with [Razorpay](https://razorpay.com).

## Installation

First, add Razorpay to your mix.exs dependencies:

```elixir
def deps do
  [{:razorpay, "~> 0.1.0"}]
end
```

Then, update your dependencies:

```sh
$ mix deps.get
```

After you've installed the dependency, you need to configure razorpay key_id and key_secret either via `config.exs` like:

```elixir
config :razorpay,
  key_id: "your_rzp_key_id",
  key_secret: "your_rzp_key_secret"
```

or as ENV variables `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`

## Usage

Check everything's working.

```elixir
iex> Razorpay.make_test_request
{:ok, %{message: "Welcome to Razorpay API."}}
```

Example:

```elixir
iex> Razorpay.Payment.get "payment_id"
{:ok,
 %Razorpay.Payment{amount: 5000, amount_refunded: 0,
  contact: "+919123456789", created_at: 1471942604, currency: "INR",
  description: "Test", email: "test@test.com", error_code: nil,
  error_description: nil, fee: 0, id: "payment_id",
  method: "netbanking", notes: [], refund_status: "partial", service_tax: 0,
  status: "authorized"}}

iex> Razorpay.Payment.capture "payment_id", 5000
{:ok,
 %Razorpay.Payment{amount: 5000, amount_refunded: 0, contact: "+919123456789",
  created_at: 1471942604, currency: "INR", description: "Test",
  email: "test@test.com", error_code: nil, error_description: nil, fee: 144,
  id: "payment_id", method: "netbanking", notes: [], refund_status: nil,
  service_tax: 19, status: "captured"}}
```

You can pass in the id or the `%Razorpay.Payment{}` as the first argument.

### Guidelines

All the entities follow the same API as mentioned above. As a general rule of thumb, the arity of each function will be equal to the number of required fields for that call. Consult the [official docs](https://docs.razorpay.com/v1/docs) for required fields.

## Notes

- Currently supports all endpoints that are described in the official documentaion. The Orders API is not documented yet, and thus have not been implemented.
- This library is *not officially supported* by Razorpay, but is well typed and tested.
- The `/payments/:id/refunds` endpoint as described in the docs, support options to be passed, but doesn't work. That particular test has been disabled for now.

If anyone from Razorpay sees this, please get in touch with me.
