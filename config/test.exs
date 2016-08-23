use Mix.Config

config :exvcr, [
  match_requests_on: [:query, :request_body]
]
