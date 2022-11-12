defmodule UnterEats.SearchHelpers do
  def to_ilike_term(term) when is_binary(term) do
    term =
      term
      |> String.trim()
      |> String.replace("%", "\\%")
      |> String.replace(~r/\s+/, "%")

    "%" <> term <> "%"
  end

  def filter_by_params(query, params, filter_callback) when is_function(filter_callback, 2) do
    Enum.reduce(params, query, filter_callback)
  end
end
