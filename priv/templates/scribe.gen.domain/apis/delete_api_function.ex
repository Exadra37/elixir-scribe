
  @doc """
  Deletes the <%= schema.singular %> for the given `id`.

  ## Examples

      iex> <%= action %>_<%= schema.singular %>(123)
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= action %>_<%= schema.singular %>(0123)
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>_<%= schema.singular %>(id), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(id)
