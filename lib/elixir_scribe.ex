defmodule ElixirScribe do
  @moduledoc """
  The Elixir Scribe Generator configuration and defaults.

  All functions in this Module **MUST** be considered private and only used internally.

  Some of the defaults will be possible to customize via your app configuration.


  ## Defaults

  ### Templates Paths

  The paths to look for template files for generators defaults to checking the current app's `priv` directory, and falls back to Elixir Scribe and Phoenix's `priv` directory:

  * `priv/templates/*`
  * `elixir_scribe/priv/templates/*`
  * `phoenix/priv/templates/*`

  ### Default Actions

  The default actions supported by `scribe.gen.domain` and `scribe.gen.html`:

  * `list` - Lists all items of a Resource in the database
  * `new` - Builds a new changeset for a Resource
  * `read` - Reads a specific Resource from the database
  * `edit` - Builds a changeset to track changes made to a Resource
  * `create` - Creates a new Resource in the database
  * `update` - Updates an existing Resource
  * `delete` - Deletes an existing Resource


  ## Configuration

  In your app configuration you can:

  * [Configure Default Actions](#module-configure-default-actions) - Provide your own list of built-in default actions that will be used each time you invoke one of the generators.
  * [Configure Default Actions Aliases](#module-configure-default-actions-aliases) - Use aliases to rename the built-in default actions to your preferred names.
  * [Configure Custom Default Actions](#module-configure-custom-default-actions) - Provide your own custom action names, that wil use the default template or one provided by your app.

  ### Configure Default Actions

  > #### Custom Default Actions {: .info}
  > Any custom action name provided via the configuration will be mapped to a default template, unless you provide your custom template(s) for it at the correct path in your app `priv/templates/*`.
  >
  > This custom action names will be added to your router as `GET` requests. You need to customize the router as needed.

  > #### Default Actions Order {: .error}
  > Order of actions **MATTERS**, otherwise routes will not work as expected.


  For example, for an API you can  discard the default actions `new` and `edit`:

  ```elixir
  config :elixir_scribe,
    default_actions: ["list", "read", "create", "update", "delete"]
  ```

  Or, maybe you want to use the default actions, plus some other ones that you always need when creating a new resource:

  ```elixir
  config :elixir_scribe,
    default_actions: ["import", "export", "list", "new", "read", "edit", "create", "update", "delete"]
  ```

  Note how `import` and `export` were added to the begin of the list to ensure they are matched correctly by the router when serving the `GET` request.

  ### Configure Default Actions Aliases

  In your app configuration for `:elixir_scribe` you can map any of the built-in default actions to actions names of your preference, which it's the same as renaming them.

  The below example maps the built-in default actions `read` to `show` and `list` to `index`.

  ```elixir
  config :elixir_scribe,
    default_actions_aliases: %{
        "read" => "show",
        "list" => "index",
      }
  ```

  ### Configure Custom Default Actions

  When using custom actions the generators can be configured to use your own templates for code generation instead of falling back to a default template.

  """

  alias Mix.Phoenix.Context
  alias ElixirScribe.MixGeneratorAPI

  @doc false
  def default_base_template_paths() do
    [".", :elixir_scribe, :phoenix]
  end

  @doc false
  def default_web_template_path() do
    "priv/templates/scribe.gen.html"
  end

  @doc false
  def default_html_template_path() do
    default_web_template_path() |> Path.join("html")
  end

  @doc false
  def default_controller_template_path() do
    default_web_template_path() |> Path.join("controllers")
  end

  @doc false
  def default_controller_test_template_path() do
    Path.join([default_web_template_path(), "tests", "controllers"])
  end

  @default_domain_template_path "priv/templates/scribe.gen.domain"
  @doc false
  def default_domain_template_path(), do: @default_domain_template_path

  @doc false
  def default_domain_api_template_path() do
    default_domain_template_path() |> Path.join("apis")
  end

  @doc false
  def default_domain_actions_template_path() do
    default_domain_template_path() |> Path.join("actions")
  end

  @doc false
  def default_domain_tests_template_path() do
    default_domain_template_path() |> Path.join("tests")
  end

  @doc false
  def default_actions() do
    # @IMPORTANT: Order of actions MATTERS, otherwise routes will not work as
    #  expected. Don't allow override from config, but allow to set aliases.
    ["list", "new", "read", "edit", "create", "update", "delete"]
  end

  @doc false
  def default_actions_aliases() do
    # @TODO Get from configuration.

    %{
      # "default_action" => "alias"
    }
  end

  @doc false
  def get_action_alias(action) do
    default_actions_aliases() |> Map.get(action, action)
  end

  @doc false
  def default_html_actions() do
    # @TODO Allow to override from configuration
    ["read", "new", "edit", "list"]
  end

  @doc false
  def default_plural_actions() do
    # @TODO Allow to override from configuration
    ["index", "list"]
  end

  @doc false
  def capitalize(string) do
    string
    |> String.split(["_", "-"], trim: true)
    |> Enum.map(fn part -> String.capitalize(part) end)
    |> Enum.join()
  end

  @doc false
  def human_capitalize(string) do
    string
    |> String.split(["_", "-"], trim: true)
    |> Enum.map(fn part -> String.capitalize(part) end)
    |> Enum.join(" ")
  end

  @doc false
  def first_word(string, separators \\ ["_", "-", " "]) do
    string
    |> String.split(separators, trim: true)
    |> List.first()
  end

  @doc false
  def create_file_from_template(root_paths, source_path, target_path, binding) do
    Mix.Generator.create_file(
      target_path,
      Mix.Phoenix.eval_from(root_paths, source_path, binding)
    )
  end

  @doc false
  def inject_into_file_from_template(root_paths, source_path, target_path, binding) do
    root_paths
    |> Mix.Phoenix.eval_from(source_path, binding)
    |> MixGeneratorAPI.inject_eex_before_final_end(target_path, binding)
  end

  @doc false
  def build_binding(%Context{} = context) do
    [context: context, schema: context.schema]
    |> rebuild_binding_with_action_aliases()
  end

  @doc false
  def rebuild_binding_with_action_aliases(binding) do
    new_bindings =
      default_actions()
      |> Keyword.new(fn action ->
        action_alias = get_action_alias(action)
        action_key = String.to_atom("#{action}_action")
        {action_key, action_alias}
      end)

    binding = Keyword.merge(binding, new_bindings)

    new_bindings =
      default_actions()
      |> Keyword.new(fn action ->
        action_alias = get_action_alias(action) |> String.capitalize()
        action_key = String.to_atom("#{action}_action_capitalized")
        {action_key, action_alias}
      end)

    Keyword.merge(binding, new_bindings)
  end

  @doc false
  def rebuild_binding(binding, action) do
    [{:context, context} | _rest] = binding

    Keyword.merge(binding,
      action: action,
      action_first_word: first_word(action),
      action_capitalized: capitalize(action),
      action_human_capitalized: human_capitalize(action),
      module_action_name:
        MixGeneratorAPI.build_absolute_module_action_name(context, action, from_schema: true)
    )
  end

  @doc false
  def schema_access_template(%Mix.Phoenix.Schema{} = schema) do
    if schema.generate? do
      "schema_access"
    else
      "no_schema_access"
    end
  end

  @doc false
  def get_base_dir(%Context{} = context) do
    context.dir |> Path.dirname()
  end

  @doc false
  def get_domains_base_dir(%Context{} = context) do
    context |> get_base_dir() |> Path.join("domains")
  end

  @doc false
  def get_test_base_dir(%Context{} = context) do
    context.test_file |> Path.dirname()
  end

  @doc false
  def get_domains_test_base_dir(%Context{} = context) do
    context |> get_test_base_dir() |> Path.join("domains")
  end

  @doc false
  def get_schema_file_path(%Context{} = context) do
    base_dir = context |> get_base_dir()
    domain = context.basename
    resource = context.schema.singular

    Path.join([base_dir, "domains", domain, resource <> ".ex"])
  end

  @doc false
  def get_resource_action_file(%Context{} = context, action) do
    base_dir = get_domains_base_dir(context)
    domain = context.basename
    resource = context.schema.singular
    filename = get_resource_action_filename(context, action, ".ex")

    Path.join([base_dir, domain, resource, "#{action}", filename])
  end

  @doc false
  def get_resource_action_test_file(%Context{} = context, action) do
    test_dir = get_domains_test_base_dir(context)
    domain = context.basename
    resource = context.schema.singular
    filename = get_resource_action_filename(context, action, "_test.exs")

    Path.join([test_dir, domain, resource, "#{action}", filename])
  end

  @doc false
  def get_resource_action_filename(%Context{} = context, action, suffix) do
    resource =
      (action in default_plural_actions() && context.schema.plural) || context.schema.singular

    "#{action}_" <> resource <> suffix
  end
end
