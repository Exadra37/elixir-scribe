
  @doc """
  Returns an `%Ecto.Changeset{}` with a default `%<%= inspect schema.alias %>{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> <%= inspect schema.alias %>API.<%= action %>()
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{}}

  """
  def <%= action %>(attrs \\ %{}) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
