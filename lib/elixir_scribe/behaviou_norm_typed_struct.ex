defmodule ElixirScribe.Behaviour.NormTypedStruct do
  @moduledoc """
  The Elixir Scribe Typed Struct guarantees the shape of your data throughout your codebase.

  Use it as a contract for your data shape to eliminate potential bugs that may be caused by creating the data with the wrong type. This leads to more robust code and fewer tests needed to guarantee data correctness, compared to when a struct or a plain map was previously used.

  ## Typed Struct

  Let's define a Person typed struct:

  ```
  #{File.read! "test/support/behaviours/person.ex"}
  ```

  A typed struct needs to declare the required and optional keys, plus a type spec for them. The type spec can use built-in specs from Norm or your own ones.

  To take advantage of the safety guarantees of the typed struct, you **MUST** not create or update it directly, as allowed by Elixir. Instead, you need to use the built-in functions `new/1`, `new!/1`, `update/3`, or `update!/3` that will guarantee it conforms with the type specs when one is created or updated.

  Use the `conforms?/1` function at the place you use the typed struct to ensure that you still have a struct that conforms with the type spec, because it may have been manipulated directly between the point it was created and where you are using it.

  For introspection, the `fields/0` and `type_spec/0` functions are provided.


  ## Usage Examples

  To create a new Person:

  ```
  iex> person = Person.new! %{name: "Paulo", age: 10}
  %Person{name: "Paulo", age: 10, email: nil, self: Person}
  ```

  To update the Person:

  ```
  iex> person = Person.new! %{name: "Paulo", age: 10}
  iex> person.self.update! person, :email, "me@gmail.com"
  %Person{name: "Paulo", age: 10, email: "me@gmail.com", self: Person}
  ```

  To confirm the Person still conforms with the type spec:

  ```
  iex> person = Person.new! %{name: "Paulo", age: 10}
  iex> person.self.conforms? person
  true
  ```

  To introspect the fields used to define the typed struct at compile time:

  ```
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

  To introspect the Norm type spec:

  ```
  iex> Person.type_spec
  #Norm.Schema<%Person{
    name: #Norm.Spec<is_binary()>,
    age: #Norm.Spec<is_integer() or is_nil()>,
    email: #Norm.Spec<email?()>,
    self: Person
  }>
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

      unless Module.has_attribute?(__MODULE__, @moduledoc) do
        @moduledoc """

        > #### INFO {: .info}
        > This module doesn't have docs, but implements the behaviour `ElixirScribe.Behaviour.NormTypedStruct` which provides the following docs.

        #{moduledocs}
        """
      end

      import Norm

      @behaviour ElixirScribe.Behaviour.NormTypedStruct

      @struct_keys Keyword.get(opts, :keys, %{}) |> Map.put(:extra, [self: __MODULE__])

      optional_fields = NormTypedStruct.__optional_fields__(@struct_keys, __MODULE__)

      @enforce_keys @struct_keys.required

      @optional_keys optional_fields

      @all_keys @enforce_keys ++ @optional_keys

      @fields %{defstruct: @all_keys, config: @struct_keys}

      defstruct @all_keys

      @impl true
      def fields(), do: @fields

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
