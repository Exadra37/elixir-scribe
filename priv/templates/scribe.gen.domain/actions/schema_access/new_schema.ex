  alias <%= inspect schema.module %>

  @doc false
  def <%= action_first_word %>() do
    <%= inspect schema.alias %>.changeset(%<%= schema.human_singular %>{}, %{})
  end
