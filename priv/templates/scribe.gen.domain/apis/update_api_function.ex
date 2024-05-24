
  @doc """
  Updates the <%= schema.singular %> `id` with the given `attrs`.

  ## Examples

      iex> <%= action %>_<%= schema.singular %>(123, %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= action %>_<%= schema.singular %>(123, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>_<%= schema.singular %>(id, attrs), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(id, attrs)
