
  @doc """
  Deletes the <%= schema.singular %> for the given `id`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>(123)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= schema.human_singular %>API.<%= action %>(0123)
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(id), do: <%= module_action_name %>.<%= action_first_word %>(id)
