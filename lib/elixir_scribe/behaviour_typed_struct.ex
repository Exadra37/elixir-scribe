defmodule ElixirScribe.Behaviour.NormTypedStruct do

  # @TODO Optional fields not working.

  @doc """
  Returns the typed specification for the struct.

  Used internally by all this behaviour callbacks, but may also be useful in the case more advanced usage of Norm is required outside this struct.
  """
  @callback type_spec() :: struct()

  @doc """
  Accepts a map with the attributes to create a typed struct.

  Returns `{:ok, struct}` on successful creation, otherwise returns `{:error, reason}`.
  """
  @callback new(map()) :: {:ok, struct()} | {:error, list(map())}

  @doc """
  Accepts a map with the attributes to create a typed struct.

  Returns the typed struct on successful creation, otherwise raises an error.
  """
  @callback new!(map()) :: struct()

  @doc """
  Updates the typed struct for the given key and value.

  Returns `{:ok, struct}` on successful update, otherwise returns `{:error, reason}`.
  """
  @callback update(struct(), atom(), any()) :: {:ok, struct()} | {:error, list(map())}

  @doc """
  Updates the typed struct for the given key and value.

  Returns the typed struct on successful update, otherwise raises an error.
  """
  @callback update!(struct(), atom(), any()) :: struct()

  @doc """
  Accepts the struct itself to check it still conforms with the specs.

  Creating or modifying the struct directly can cause it to not be conformant anymore with the specs.

  Useful to use by modules operating on the struct that need to ensure it wasn't directly modified after being created with `new/1` or `new!/1`.
  """
  @callback conforms?(struct()) :: boolean()

  defmacro __using__(opts) do
    quote location: :keep, bind_quoted: [opts: opts] do
      import Norm

      @behaviour ElixirScribe.Behaviour.NormTypedStruct

      @struct_keys Keyword.get(opts, :keys, [])
      @enforce_keys @struct_keys.required
      @optional_keys @struct_keys.optional ++ [self: __MODULE__]
      @all_keys @enforce_keys ++ @optional_keys

      defstruct @all_keys

      @impl true
      def new(attrs) when is_map(attrs) do
        struct(__MODULE__, attrs)
        |> conform(type_spec())
      end

      @impl true
      def new!(attrs) when is_map(attrs) do
        struct(__MODULE__, attrs)
        |> conform!(type_spec())
      end

      @impl true
      def update(%__MODULE__{} = struct, key, value) do
        struct
        |> Map.put(key, value)
        |> conform(type_spec())
      end

      @impl true
      def update!(%__MODULE__{} = struct, key, value) do
        struct
        |> Map.put(key, value)
        |> conform!(type_spec())
      end

      @impl true
      def conforms?(%__MODULE__{} = struct), do: struct |> valid?(type_spec())
      def conforms?(_), do: false

      defoverridable new: 1, new!: 1, update: 3, update!: 3, conforms?: 1
    end
  end
end
