defmodule ElixirScribe.Behaviour.NormTypedStruct do
  @moduledoc """
  The Elixir Scribe Typed Struct built on top of Norm.

  ## Typed Struct

  Let's define a Person typed struct:

  ```
  defmodule Person do
    @keys %{
      required: [:name],
      optional: [age: nil, email: nil]
    }

    use ElixirScribe.Behaviour.NormTypedStruct, keys: @keys

    @impl true
    def type_spec() do
       schema(%__MODULE__{
        name: is_binary() |> spec(),
        age: spec(is_integer() or is_nil()),
        email: spec(email?())
      })
    end

    # A very simplistic email validation for demo purposes.
    defp email?(email) when is_binary(email), do: String.contains?(email, "@")

    # email is optional, therefore it conforms with it's default value of nil.
    defp email?(nil), do: true

    defp email?(_email), do: false
  end
  ```

  A typed struct needs to declare the required and optional keys, plus a type spec for them. The type spec can use built-in specs from Norm or your own ones.

  To take advantage of the safety guarantees of the typed struct you MUST not create or update it directly, as allowed by Elixir, instead you need to use the built-in functions `new/1`, `new!/1`, `update/3` or `update!/3` that will guarantee it conforms with the type specs when one is created or updated.

  Use `conforms?/1` at the place you gonna use the typed struct to guarantee that you still have a struct that conforms with the type spec, because it may have been manipulated directly between the point it was created and where you will use it.

  For introspection the `fields/0` and `type_spec/0` are provided.


  ## Usage Examples

  To create a new Person:

  ```
  iex> person = Person.new! %{name: "Paulo", age: 10}
  %Person{name: "Paulo", age: 10, email: nil, self: Person}
  ```

  To update the Person:

  ```
  iex> person.self.update! person, :email, "me@gmail.com"
  %Person{name: "Paulo", age: 10, email: "me@gmail.com", self: Person}
  ```

  To confirm the Person still conforms with the type spec:

  ```
  iex> person.self.conforms? person
  true
  ```

  To introspect the fields used to define the typed struct at compile time:

  ```
  iex> person.self.fields
  %{
    config: %{
      extra: [self: Person],
      required: [:name],
      optional: [age: nil, email: nil]
    },
    defstruct: [:name, {:age, nil}, {:email, nil}, {:self, Person}]
  }

  iex> Person.fields
  %{
    config: %{
      extra: [self: Person],
      required: [:name],
      optional: [age: nil, email: nil]
    },
    defstruct: [:name, {:age, nil}, {:email, nil}, {:self, Person}]
  }
  ```

  The `:self` field is an extra added at compile time by the typed struct macro to allow you to self reference the typed struct like you already noticed in the above examples.
  """

  alias ElixirScribe.Behaviour.NormTypedStruct

  @doc """
  Returns the typed specification for the struct.

  Used internally by all this behaviour callbacks, but may also be useful in the case more advanced usage of Norm is required outside this struct.
  """
  @callback type_spec() :: struct()

  @doc """
  Returns the fields definition used to define the struct at compile time.

  ## Usage Examples

  To know which fields are required and optional in the typed struct:

      iex> person = Person.fields
      %{
        config: %{extra: [self: Person], required: [:name], optional: [age: nil]},
        defstruct: [:name, {:age, nil}, {:self, Person}]
      }


  """
  @callback fields() :: map()

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

  def __optional_fields__(%{optional: optional, extra: extra}, module) do
    Keyword.keyword?(optional) || raise """
      #{module}

          All optional fields in a Struct MUST have a default value:

            * Incorrect: [:a, :b] or [:a, b: :default]

            * Correct: [a: :default, b: :default]

          Your fields:

          #{inspect(optional)}
      """

    optional ++ extra
  end
  def __optional_fields__(%{extra: extra}, _module), do: extra

  defmacro __using__(opts) do
    moduledocs = @moduledoc

    quote location: :keep, bind_quoted: [opts: opts, moduledocs: moduledocs] do
      @moduledoc """
      #{moduledocs}
      """

      import Norm

      @behaviour ElixirScribe.Behaviour.NormTypedStruct

      @struct_keys Keyword.get(opts, :keys, %{}) |> Map.put(:extra, [self: __MODULE__])

      optional_fields = NormTypedStruct.__optional_fields__(@struct_keys, __MODULE__)

      @enforce_keys @struct_keys.required

      @optional_keys optional_fields

      @all_keys @enforce_keys ++ @optional_keys

      @fields %{defstruct: @all_keys, config: @struct_keys}

      defstruct @all_keys

      # @impl true
      def fields(), do: @fields

      @impl true
      @doc
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
