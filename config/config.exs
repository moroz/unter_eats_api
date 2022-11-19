# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :unter_eats,
  ecto_repos: [UnterEats.Repo]

config :unter_eats, UnterEats.Repo, migration_primary_key: [name: :id, type: :binary_id]

# Configures the endpoint
config :unter_eats, UnterEatsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: UnterEatsWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: UnterEats.PubSub,
  live_view: [signing_salt: "e1sV5cFq"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :unter_eats, UnterEats.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :waffle,
  storage: Waffle.Storage.S3,
  asset_host: {:system, "ASSET_HOST"},
  bucket: {:system, "AWS_S3_BUCKET"}

config :ex_aws,
  json_codec: Jason,
  access_key_id: {:awscli, :system, 30},
  secret_access_key: {:awscli, :system, 30},
  region: "eu-central-1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
