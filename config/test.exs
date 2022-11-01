import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :unter_eats, UnterEats.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "unter_eats_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :unter_eats, UnterEatsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "AtKe0cHZ9WzhDDQ1frdySncerzsXJFS2NzfnBnCAVaiPNqnEbQHaSJpxHxOMwdYq",
  server: false

# In test we don't send emails.
config :unter_eats, UnterEats.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :stripity_stripe,
  api_key: "sk_test_thisisaboguskey",
  api_base_url: "http://localhost:12111/v1/"
