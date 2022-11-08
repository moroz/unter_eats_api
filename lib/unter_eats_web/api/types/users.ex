defmodule UnterEatsWeb.Api.Types.Users do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.UserResolvers

  object :user do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :full_name, non_null(:string)

    timestamps()
  end

  object :user_queries do
    field :current_user, :user do
      resolve(&UserResolvers.current_user/2)
    end
  end
end
