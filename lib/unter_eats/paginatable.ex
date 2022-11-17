defmodule UnterEats.Paginatable do
  @callback base_query() :: Ecto.Queryable.t()
  @callback filter_by_params({atom(), term()}, Ecto.Queryable.t()) :: Ecto.Queryable.t()
  @optional_callbacks filter_by_params: 2

  alias UnterEats.Repo

  def filter_and_paginate_resource(module, params) when is_atom(module) do
    query = module.base_query()

    params
    |> Enum.reduce(query, &module.filter_by_params/2)
    |> Repo.paginate(params)
  end

  defmacro __using__(resource_name) when is_atom(resource_name) do
    function_name = :"filter_and_paginate_#{resource_name}"

    quote do
      @behaviour UnterEats.Paginatable
      import Ecto.Query, warn: false

      def filter_by_params(_, query), do: query

      defoverridable filter_by_params: 2

      def unquote(function_name)(params),
        do: UnterEats.Paginatable.filter_and_paginate_resource(__MODULE__, params)
    end
  end
end
