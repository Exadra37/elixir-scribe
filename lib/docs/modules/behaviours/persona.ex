defmodule Persona do
  @moduledoc false

  require PersonaValidator

  @fields %{
    required: [:name, :email],
    optional: [role: nil]
  }

  use ElixirScribe.Behaviour.TypedContract, fields: @fields

  @impl true
  def type_spec() do
    schema(%__MODULE__{
      name: is_binary() |> spec(),
      email: PersonaValidator.corporate_email?() |> spec(),
      role: PersonaValidator.role?() |> spec()
    })
  end
end
