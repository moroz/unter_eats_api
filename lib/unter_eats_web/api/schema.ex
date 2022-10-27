defmodule UnterEatsWeb.Api.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(UnterEatsWeb.Api.Types.Categories)
  import_types(UnterEatsWeb.Api.Types.Products)

  query do
    import_fields(:product_queries)
    import_fields(:category_queries)
  end

  alias UnterEatsWeb.Api.Middleware.TransformErrors
  alias UnterEatsWeb.Api.Middleware.RestrictAccess
  alias GraphQLTools.ResolutionWithErrorBoundary

  # @public_queries [:current_user]
  # def middleware(middleware, %{identifier: id}, %{identifier: :query})
  #     when id in @public_queries do
  #   middleware
  # end

  @public_mutations [:sign_in, :sign_out, :sign_up]
  def middleware(middleware, %{identifier: id}, %{identifier: :mutation})
      when id in @public_mutations do
    middleware
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :query}) do
    List.flatten([
      # RestrictAccess,
      ResolutionWithErrorBoundary.replace_resolution_middleware(middleware)
    ])
  end

  def middleware(middleware, _field, %Absinthe.Type.Object{identifier: :mutation}) do
    List.flatten([
      RestrictAccess,
      ResolutionWithErrorBoundary.replace_resolution_middleware(middleware),
      TransformErrors
    ])
  end

  def middleware(middleware, _field, _object), do: middleware
end
