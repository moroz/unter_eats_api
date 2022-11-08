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

  object :sign_in_mutation_result do
    mutation_result_fields(:user)
  end

  object :user_mutations do
    field :sign_in, non_null(:sign_in_mutation_result) do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      middleware(UnterEatsWeb.Api.SignIn)
    end

    @desc "Signs user out, removing all user data from the session."
    field :sign_out, non_null(:boolean) do
      middleware(UnterEatsWeb.Api.Middleware.SignOut)
    end
  end
end
