
  @doc """
  Creates a <%= schema.singular %> from the given `attrs`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>(%{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= schema.human_singular %>API.<%= action %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(attrs) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
