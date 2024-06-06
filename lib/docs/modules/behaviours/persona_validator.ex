defmodule PersonaValidator do
  @moduledoc false

  # A very simplistic set o validations used by the docs usage examples.

  @email_providers ["gmail.com", "yahoo.com", "hotmail.com"]
  def corporate_email?(email) when is_binary(email) do
    case String.split(email, "@", trim: true) do
      [_one_part] ->
        false

      [_, email_provider] when email_provider not in @email_providers ->
        true

      _ ->
        false
    end
  end

  def corporate_email?(_email), do: false

  # The role is optional, thus we return true
  def role?(role) when is_nil(role), do: true

  def role?(role) when is_binary(role) do
    role = role |> String.trim()
    String.length(role) >= 3
  end

  def role?(_age), do: false
end
