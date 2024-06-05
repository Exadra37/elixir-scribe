defmodule ElixirScribe.Behaviour.NormTypedStruct do
  @moduledoc """
  The Elixir Scribe Typed Struct guarantees the shape of your data throughout your codebase.

  Use it as a contract for your data shape to eliminate potential bugs that may be caused by creating the data with the wrong type. This leads to more robust code and fewer tests needed to guarantee data correctness, compared to when a struct or a plain map was previously used.


  ## Typed Struct

  Let's imagine that the Business requested a new feature, a Marketing funnel where they only want to allow personas who have a company email to enter the funnel, and they require them to provide a name, email and optionally their role in the company.

  We can use a Typed Struct to translate these business rules into a contract that guarantees data correctness across all our code base.

  For simplicity of the usage examples let's call it `Persona`:

  ```
  #{File.read! "lib/docs/modules/behaviours/persona.ex"}
  ```
  > ### Specs {: .info}
  > - When defining the `type_spec/0` the schema can use the built-in specs from [Norm](https://hexdocs.pm/norm/Norm.html#module-validation-and-conforming-values) or your own ones.
  > - All specs defined with `PersonaValidator.*` are custom ones.


  > ### Required and Optional Keys {: .warning}
  > - A typed struct needs to declare the required and optional keys, plus a type spec for them.
  > - The optional keys **MUST** have a default value.

  > ### Contract Guarantees {: .error}
  > - To take advantage of the safety guarantees of the typed struct contract, you **MUST** not create or update it directly, as allowed by Elixir. Instead, you need to use the built-in functions `new/1`, `new!/1`, `update/3`, or `update!/3` that will guarantee it conforms with the type specs when one is created or updated.
  > - Use the `conforms?/1` function at the place you use the typed struct to ensure that you still have a struct that conforms with the type spec, because it may have been manipulated directly between the point it was created and where you are using it.
  > - For introspection, the `fields/0` and `type_spec/0` functions are provided.


  ## Usage Examples

  To run the usage examples:

  ```
  iex -S mix
  ```

  ### With Valid Data Types

  To create a new Person:

  ```
  iex> Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  ```

  To update the Person:

  ```
  iex> persona = Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  iex> persona.self.update! persona, :role, "Elixir Scribe Engineer"
  %Persona{
    name: "Paulo",
    email: "exadra37@company.com",
    role: "Elixir Scribe Engineer",
    self: Persona
  }
  ```

  Later, some layers deep in the code we can confirm that the Persona still conforms with the type spec defined in the contract:

  ```
  iex> persona = Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  iex> persona.self.conforms? persona
  true
  ```

  Alternatively, you can use `new/1` and `update/3` which will return a `{:ok, result}` or `{:error, reason}` tuple.


  ### With Invalid Data Types

  Passing the role as an atom, instead of the expected string:

  ```
  iex> Persona.new %{name: "Paulo", email: "exadra37@company.com", role: :cto}
  {:error, [%{input: :cto, path: [:role], spec: "PersonaValidator.role?()"}]}
  ```

  The same as above, but using `new!/1` which will raise:

  ```
  Persona.new! %{name: "Paulo", email: "exadra37@company.com", role: :cto}
  ```

  It will raise the following:

  ```
  ** (Norm.MismatchError) Could not conform input:
  val: :cto in: :role fails: PersonaValidator.role?()
      (norm 0.13.0) lib/norm.ex:65: Norm.conform!/2
      iex:6: (file)
  ```

  Invoking `update/3` and `update!/3` will output similar results.

  > ### Less Tests and Fewer Bugs {: .tip}
  > - The Elixir Scribe typed struct acts as a contract for the businesse rules to guarantee data correctness at anypoint it's used in the code base.
  > - Now the developer only needs to test that a Persona complies with this business rules in the test for this contract, because everywhere the Persona contract is used it's guaranteed that the data is in the expected shape.
  > - This translates to fewer bugs, less technical debt creeping in and a more robust code base.

  ### Introspection

  To introspect the fields used to define the typed struct at compile time:

  ```
  iex> Persona.fields
  %{
    config: %{
      extra: [self: Persona],
      required: [:name, :email],
      optional: [role: nil]
    },
    defstruct: [:name, :email, {:role, nil}, {:self, Persona}]
  }
  ```

  To introspect the Norm type spec:

  ```
  iex> Persona.type_spec
  ```

  The output:

  ```
  #Norm.Schema<%Persona{
    name: #Norm.Spec<is_binary()>,
    email: #Norm.Spec<PersonaValidator.corporate_email?()>,
    role: #Norm.Spec<PersonaValidator.role?()>,
    self: Persona
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
