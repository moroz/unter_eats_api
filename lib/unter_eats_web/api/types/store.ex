defmodule UnterEatsWeb.Api.Types.Store do
  use Absinthe.Schema.Notation
  alias UnterEatsWeb.Api.Middleware.RestrictAccess
  alias UnterEatsWeb.Api.Resolvers.StoreResolvers
  import GraphQLTools.SchemaHelpers

  object :business_log do
    field :id, non_null(:id)
    field :start_time, non_null(:datetime)
    field :end_time, :datetime
  end

  object :business_log_page do
    pagination_fields(:business_log)
  end

  input_object :business_log_pagination_params do
    standard_pagination_params()
  end

  object :business_log_mutation_result do
    mutation_result_fields(:business_log)
  end

  object :store_queries do
    field :paginate_business_logs, non_null(:business_log_page) do
      arg(:params, :business_log_pagination_params)
      middleware(RestrictAccess)
      resolve(&StoreResolvers.filter_and_paginate_business_logs/2)
      middleware(GraphQLTools.FormatPage)
    end

    field :is_store_open, non_null(:boolean) do
      resolve(&StoreResolvers.is_store_open/2)
    end
  end

  object :store_mutations do
    field :close_store, non_null(:business_log_mutation_result) do
      middleware(RestrictAccess)
      resolve(&StoreResolvers.close_store/2)
    end

    field :open_store, non_null(:business_log_mutation_result) do
      middleware(RestrictAccess)
      resolve(&StoreResolvers.open_store/2)
    end
  end
end
