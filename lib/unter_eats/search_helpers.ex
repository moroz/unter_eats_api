defmodule UnterEats.SearchHelpers do
  def to_ilike_term(term) when is_binary(term) do
    term =
      term
      |> String.trim()
      |> String.replace("%", "\\%")
      |> String.replace(~r/\s+/, "%")

    "%" <> term <> "%"
  end
end
