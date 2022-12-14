defmodule UnterEats.MixProject do
  use Mix.Project

  def project do
    [
      app: :unter_eats,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {UnterEats.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.6.15"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_view, "~> 0.18.3"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5"},
      {:absinthe_phoenix, "~> 2.0"},
      {:graphql_tools, github: "moroz/graphql_tools"},
      {:shorter_maps, "~> 2.2"},
      {:ex_machina, "~> 2.7"},
      {:scrivener_ecto, "~> 2.7"},
      {:cors_plug, "~> 3.0"},
      {:appsignal_phoenix, "~> 2.0"},
      {:stripity_stripe, "~> 2.0"},
      {:bcrypt_elixir, "~> 3.0"},
      {:slugify, "~> 1.3"},
      {:ecto_enum, "~> 1.4"},
      {:timex, "~> 3.7"},
      {:waffle, "~> 1.1"},
      {:waffle_ecto, "~> 0.0.11"},
      {:ex_aws, "~> 2.1.2"},
      {:ex_aws_s3, "~> 2.0"},
      {:hackney, "~> 1.9"},
      {:sweet_xml, "~> 0.6"},
      {:configparser_ex, "~> 4.0"},
      {:swoosh, "~> 1.8"},
      {:phoenix_swoosh, "~> 1.1"},
      {:gen_smtp, "~> 1.0"},
      {:absinthe_json_scalar, "~> 0.1.0"},
      {:email_tld_validator, "~> 0.1.0"},
      {:ex_phone_number, "~> 0.3.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      seed: ["cmd psql unter_eats_dev -f priv/repo/seeds.sql"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "seed"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
