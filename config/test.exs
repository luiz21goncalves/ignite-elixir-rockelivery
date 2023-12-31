import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :rockelivery, Rockelivery.Repo,
  username: "docker",
  password: "docker",
  hostname: "localhost",
  database: "ignite-elixir-rockelivery#{System.get_env("MIX_TEST_PARTITION")}",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :rockelivery, Rockelivery.Users.Create,
  brasil_api_adapter: Rockelivery.BrasilApi.ClientMock

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rockelivery, RockeliveryWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "C4wtO3lppuwK82lF172Gh+maIUUxvQLZRLzy2QAnVd9+MMU3ede2m22x/nkA6dk9",
  server: false

# In test we don't send emails.
config :rockelivery, Rockelivery.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
