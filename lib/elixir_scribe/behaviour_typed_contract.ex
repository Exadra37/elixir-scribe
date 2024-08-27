defmodule ElixirScribe.Behaviour.TypedContract do
  @moduledoc """
  The Elixir Scribe Typed Contract guarantees the shape of your data throughout your codebase.

  Use it as a contract for your data shape to eliminate potential bugs that may be caused by creating the data with the wrong type. This leads to more robust code and fewer tests needed to guarantee data correctness, compared to when a struct or a plain map was previously used.


  ## Typed Contract

  Let's imagine that the Business requested a new feature, a Marketing funnel where they only want to allow personas who have a company email to enter the funnel, and they require them to provide a name, email and optionally their role in the company.

  We can use a Typed Contract to translate these business rules into a contract that guarantees data correctness across all our code base.

  For example:

  ```
  #{File.read!("lib/docs/modules/behaviours/persona.ex")}
  ```
  > ### Specs {: .info}
  > - When defining the `type_spec/0` the schema can use the built-in specs from [Norm](https://hexdocs.pm/norm/Norm.html#module-validation-and-conforming-values) or your own ones.
  > - All specs defined with `PersonaValidator.*` are custom ones.


  > ### Required and Optional Keys {: .warning}
  > - A typed contract needs to declare the required and optional keys, plus a type spec for them.
  > - The optional keys **MUST** have a default value.

  > ### Contract Guarantees {: .error}
  > - To take advantage of the safety guarantees offered by the Elixir Scribe Typed Contract, you **MUST** not create or update it directly, as allowed by Elixir. Instead, you need to use the built-in functions `new/1`, `new!/1`, `update/3`, or `update!/3` that will guarantee it conforms with the type specs when one is created or updated.
  > - Use the `conforms?/1` function at the place you use the typed contract to ensure that you still have a struct that conforms with the type spec, because it may have been manipulated directly between the point it was created and where you are using it.
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

  Alternatively, you can use `new/1` and `update/3` which will return a `{:ok, result}` or `{:error, reason}` tuple.


  ### With Invalid Data Types

  Passing the role as an atom, instead of the expected string:

  ```
  iex> Persona.new %{name: "Paulo", email: "exadra37@company.com", role: :cto}
  {:error, [%{input: :cto, path: [:role], spec: "PersonaValidator.role?()"}]}
  ```

  The same as above, but using `new!/1` that will raise:

  ```
  iex> Persona.new! %{name: "Paulo", email: "exadra37@company.com", role: :cto}
  ** (Norm.MismatchError) Could not conform input:
  val: :cto in: :role fails: PersonaValidator.role?()
  ```

  Invoking `update/3` and `update!/3` will output similar results.

  > ### Less Tests and Fewer Bugs {: .tip}
  > - The Elixir Scribe typed contract acts as a contract for the businesse rules to guarantee data correctness at anypoint it's used in the code base.
  > - Now the developer only needs to test that a Persona complies with this business rules in the test for this contract, because everywhere the Persona contract is used it's guaranteed that the data is in the expected shape.
  > - This translates to fewer bugs, less technical debt creeping in and a more robust code base.


  ### Validation

  When using an Elixir Typed Contract through your code base you may want to ensure that the contract still conforms with the type spec, because it may have been directly manipulated, which may break it's guarantees. This is a limitation of the ELixir language, not of the typed contract implementation.

  Let's create a valid Persona typed contract and then check if it still conforms:

  ```
  iex> persona = Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  iex> # Some layers deeper on your code you can ensure it still conforms:
  iex> persona.self.conforms persona
  {:ok,
   %Persona{
     name: "Paulo",
     email: "exadra37@company.com",
     role: nil,
     self: Persona
   }}
  iex> # Or if you prefer you can use the bang function:
  iex> persona.self.conforms! persona
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  ```

  This time let's create again a valid Persona typed contract, manipulated it directly with an invalid value and then check if it still conforms:

  ```
  iex> persona = Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  iex> # Manipulating the struct directly with the invalid value `:dev` for the `:role` field:
  iex> persona = %{persona | role: :dev}
  %Persona{
    name: "Paulo",
    email: "exadra37@company.com",
    role: :dev,
    self: Persona
  }
  iex> # The direct manipulation of a struct allows to update it with invalid values for the contract
  iex> # To mitigate the contract violation we just need to check it still conforms:
  iex> persona.self.conforms persona
  {:error, [%{input: :dev, path: [:role], spec: "PersonaValidator.role?()"}]}
  iex> # If you prefer to let it crash, then use:
  iex> persona.self.conforms! persona
  ** (Norm.MismatchError) Could not conform input:
  val: :dev in: :role fails: PersonaValidator.role?()
  ```

  You can also use `conform?/1` to only get a boolean back:

  ```
  iex> persona = Persona.new! %{name: "Paulo", email: "exadra37@company.com"}
  %Persona{name: "Paulo", email: "exadra37@company.com", role: nil, self: Persona}
  iex> persona.self.conforms? persona
  true
  ```

  ### Introspection

  To introspect the fields used to define the typed contract at compile time:

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

  The `:self` field is an extra added at compile time by the typed contract macro to allow you to self reference the typed contract like you already noticed in the above examples.
  """

  alias ElixirScribe.Behaviour.TypedContract

  @doc """
  Returns the type specification for the Elixir Scribe Typed Contract.

  Used internally by all this behaviour callbacks, but may also be useful in the case more advanced usage of Norm is required outside this struct.
  """
  @callback type_spec() :: struct()

  @doc """
  Returns the fields definition used to define the struct for the Elixir Scribe Typed Contract at compile time.
  """
  @callback fields() :: map()

  @doc """
  Accepts a map with the attributes to create an Elixir Scribe Typed Contract.

  Returns `{:ok, struct}` on successful creation, otherwise returns `{:error, reason}`.
  """
  @callback new(map()) :: {:ok, struct()} | {:error, list(map())}

  @doc """
  Accepts a map with the attributes to create an ELixir Scribe Typed Contract.

  Returns the typed contract on successful creation, otherwise raises an error.
  """
  @callback new!(map()) :: struct()

  @doc """
  Updates the Elixir Scribe Typed Contract for the given key and value.

  Returns `{:ok, struct}` on successful update, otherwise returns `{:error, reason}`.
  """
  @callback update(struct(), atom(), any()) :: {:ok, struct()} | {:error, list(map())}

  @doc """
  Updates the Elixir Scribe Typed Contract for the given key and value.

  Returns the typed contract on successful update, otherwise raises an error.
  """
  @callback update!(struct(), atom(), any()) :: struct()

  @doc """
  Accepts the Elixir Scribe Typed Contract itself to check it still conforms with the specs.

  Returns `{:ok, struct}` on success, otherwise returns `{:error, reason}`.
  """
  @callback conforms(struct()) :: {:ok, struct()} | {:error, list(map())}

  @doc """
  Accepts the Elixir Scribe Typed Contract itself to check it still conforms with the specs.

  Returns the typed contract on success, otherwise raises an error.
  """
  @callback conforms!(struct()) :: struct()

  @doc """
  Accepts the Elixir Scribe Typed Contract itself to check it still conforms with the specs.

  Creating or modifying the struct directly can cause it to not be conformant anymore with the specs.

  Useful to use by modules operating on the Typed Contract to ensure it wasn't directly modified after being created with `new/1` or `new!/1`.
  """
  @callback conforms?(struct()) :: boolean()

  def __optional_fields__(%{optional: optional, extra: extra}, module) do
    Keyword.keyword?(optional) ||
      raise """
      #{module}

          All optional fields in the Typed Contract MUST have a default value:

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
      unless Module.get_attribute(__MODULE__, :moduledoc, false) do
        @moduledoc """
        Module visible without docs.

        > #### INFO {: .info}
        > This module doesn't have docs, but you can read instead the docs for the behaviour it implements: `ElixirScribe.Behaviour.TypedContract`
        """
      end

      import Norm

      @behaviour ElixirScribe.Behaviour.TypedContract

      @contract_spec Keyword.get(opts, :keys, %{})

      @contract_keys @contract_spec.required ++ @contract_spec.optional

      @struct_keys @contract_keys |> Map.put(:extra, self: __MODULE__)

      @enforce_keys @struct_keys.required

      @optional_keys TypedContract.__optional_fields__(@struct_keys, __MODULE__)

      @all_keys @enforce_keys ++ @optional_keys

      @fields %{defstruct: @all_keys, config: @struct_keys}

      defstruct @all_keys

      @impl true
      def fields(), do: @fields

      @impl true
      @doc """
      Accepts a map with the attributes to create an ELixir Scribe Typed Contract.

      Accepted attributes: #{inspect(@contract_spec)}.

      Success response: {:ok, %#{__MODULE__}{}}

      Error response: {:error, list(map())}
      """
      def new(attrs) when is_map(attrs) do
        struct(__MODULE__, attrs)
        |> conform(type_spec())
      end

      @impl true
      @doc """
      Accepts a map with the attributes to create an ELixir Scribe Typed Contract.

      Accepted attributes: #{inspect(@contract_spec)}.

      Success response: %#{__MODULE__}{}

      Raises an error when it fails to create the contract.
      """
      def new!(attrs) when is_map(attrs) do
        struct(__MODULE__, attrs)
        |> conform!(type_spec())
      end

      @impl true
      @doc """
      Updates the Elixir Scribe Typed Contract for the given key and value.

      Accepted attributes: #{inspect(@contract_keys)}.

      Success response: {:ok, %#{__MODULE__}{}}

      Error response: {:error, list(map())}
      """
      def update(%__MODULE__{} = typed_contract, key, value) do
        typed_contract
        |> Map.put(key, value)
        |> conform(type_spec())
      end

      @impl true
      @doc """
      Updates the Elixir Scribe Typed Contract for the given key and value.

      Accepted attributes: #{inspect(@contract_keys)}.

      Success response: {:ok, %#{__MODULE__}{}}

      Raises an error when it fails to update the contract.
      """
      def update!(%__MODULE__{} = typed_contract, key, value) do
        typed_contract
        |> Map.put(key, value)
        |> conform!(type_spec())
      end

      @impl true
      def conforms(typed_contract) do
        typed_contract |> conform(type_spec())
      end

      @impl true
      def conforms!(typed_contract) do
        typed_contract |> conform!(type_spec())
      end

      @impl true
      def conforms?(%__MODULE__{} = typed_contract), do: typed_contract |> valid?(type_spec())
      def conforms?(_), do: false

      defoverridable new: 1, new!: 1, update: 3, update!: 3, conforms?: 1
    end
  end
end
