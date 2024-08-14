
  @doc """
  Updates the <%= schema.singular %> `uuid` with the given `attrs`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>("38cd0012-79dc-4838-acc0-94d4143c4f2c", %{field: new_value})
      {:ok, %<%= inspect schema.alias %>{}}

      iex> <%= schema.human_singular %>API.<%= action %>("38cd0012-79dc-4838-acc0-94d4143c4f2c", %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def <%= action %>(uuid, attrs) when is_binary(uuid) and is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(uuid, attrs)
