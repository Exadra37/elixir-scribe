defmodule Person do
  @keys %{
    required: [:name],
    optional: [age: nil, email: nil]
  }

  use ElixirScribe.Behaviour.NormTypedStruct, keys: @keys

  @impl true
  def type_spec() do
     schema(%__MODULE__{
      name: is_binary() |> spec(),
      age: spec(is_integer() or is_nil()),
      email: spec(email?())
    })
  end

  # A very simplistic email validation for demo purposes.
  defp email?(email) when is_binary(email), do: String.contains?(email, "@")

  # email is optional, therefore it conforms with it's default value of nil.
  defp email?(nil), do: true

  defp email?(_email), do: false
end
