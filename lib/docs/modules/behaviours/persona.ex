defmodule Persona do
  @moduledoc false

  require PersonaValidator

  @keys %{
    required: [:name, :email],
    optional: [role: nil]
  }

  use ElixirScribe.Behaviour.TypedContract, keys: @keys

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      name: is_binary() |> spec(),
      email: PersonaValidator.corporate_email?() |> spec(),
      role: PersonaValidator.role?() |> spec()
    })
  end
end
