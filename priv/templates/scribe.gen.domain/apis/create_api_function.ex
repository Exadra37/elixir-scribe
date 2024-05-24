
  @doc """
  Creates a <%= schema.singular %> from the given `attrs`.

  ## Examples

      iex> <%= action %>_<%= schema.singular %>(%{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= action %>_<%= schema.singular %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>_<%= schema.singular %>(attrs), do: <%= action_capitalized %><%= schema.human_singular %>.<%= action_first_word %>(attrs)
