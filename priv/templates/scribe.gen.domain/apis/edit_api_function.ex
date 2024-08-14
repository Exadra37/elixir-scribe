
  @doc """
  Returns an `%Ecto.Changeset{}` with a `%<%= context.schema.human_singular %>{}` for tracking changes for the given <%= schema.singular %> `uuid`.

  ## Examples

      iex> <%= schema.human_singular %>API.<%= action %>("38cd0012-79dc-4838-acc0-94d4143c4f2c")
      %Ecto.Changeset{data: %<%= inspect schema.alias %>{uuid: uuid}}

  """
  def <%= action %>(uuid, attrs \\ %{}) when is_binary(uuid) and is_map(attrs), do: <%= module_action_name %>.<%= action_first_word %>(uuid, attrs)
