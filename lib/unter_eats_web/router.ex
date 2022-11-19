defmodule UnterEatsWeb.Router do
  use UnterEatsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug UnterEatsWeb.Plug.FetchUser
  end

  scope "/api" do
    pipe_through :api

    post "/", Absinthe.Plug,
      schema: UnterEatsWeb.Api.Schema,
      socket: UnterEatsWeb.Socket,
      before_send: {GraphQLTools.SessionHelpers, :before_send}

    get "/", Absinthe.Plug.GraphiQL, schema: UnterEatsWeb.Api.Schema, interface: :playground
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview

      get "/order_placed", UnterEatsWeb.EmailTestController, :order_placed
    end
  end
end
