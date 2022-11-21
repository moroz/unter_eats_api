defmodule UnterEats.PhoneValidator do
  import Ecto.Changeset

  def normalize_number(phone_no) when is_binary(phone_no) do
    with {:ok, parsed} <- ExPhoneNumber.parse(phone_no, "PL"),
         true <- ExPhoneNumber.is_valid_number?(parsed) do
      phone_no =
        parsed
        |> ExPhoneNumber.format(:international)
        |> String.replace(~r/\s/, "")

      {:ok, phone_no}
    else
      _ -> :error
    end
  end

  def validate_phone_number(%Ecto.Changeset{} = changeset, field_name \\ :phone_no) do
    case get_change(changeset, field_name) do
      nil ->
        changeset

      phone_no ->
        normalize_or_reject_number(changeset, field_name, phone_no)
    end
  end

  defp normalize_or_reject_number(changeset, field_name, phone_no) do
    case normalize_number(phone_no) do
      {:ok, normalized} ->
        put_change(changeset, field_name, normalized)

      :error ->
        add_error(changeset, field_name, "invalid phone number")
    end
  end
end
