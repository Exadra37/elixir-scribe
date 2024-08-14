
  @doc """
  Returns an `%Ecto.Changeset{}` with a default `%<%=  context.schema.human_singular %>{}` for tracking <%= schema.singular %> changes.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>()
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{}}

  """
  def <%= action %>(attrs \\ %{}) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
