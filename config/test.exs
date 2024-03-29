use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :live_test, LiveTestWeb.Endpoint,
  http: [port: 4002],
  server: false

config :live_test, LiveTestWeb.Endpoint,
  live_view: [
    signing_salt: "6KPWeVOorN3OY54bT+P2yI3S5pccomVd"
  ]

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :live_test, LiveTest.Repo,
  username: "postgres",
  password: "postgres",
  database: "live_test_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
