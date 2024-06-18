
  @doc """
  Returns an `%Ecto.Changeset{}` with a `%<%= context.schema.human_singular %>{}` for tracking changes for the given <%= schema.singular %> `id`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>(123)
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{id: id}}

  """
  def <%= action %>(id, attrs \\ %{}) when is_map(attrs), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(id, attrs)
