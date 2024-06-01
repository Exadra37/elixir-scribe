defmodule ElixirScribe.Behaviour.TypedStruct do

  @callback s() :: struct()

  @doc """
  Accepts a map with the attributes to create a typed struct.

  On sucessefull creation it retuns `{:ok, struct}`, otherwise returns `{:error, reason}`

  """
  @callback new(map()) :: {:ok, struct()} | {:error, atom() | String.t}
  @callback new!(map()) :: struct()

end
