
  @doc """
  Creates a <%= schema.singular %> from the given `attrs`.

  ## Examples

      iex> <%= inspect schema.alias %>API.<%= action %>(%{field: value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= inspect schema.alias %>API.<%= action %>(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(attrs) when is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(attrs)
