defmodule Mix.Tasks.Scribe.Gen.Html do
  @shortdoc "Generates the domain and controller for an HTML resource"

  @moduledoc """
  Generates a module per action for a resource within a domain at `lib/my_app_web/*` and `lib/my_app/*`, with the related tests. This includes the controller, view, templates, the schema, the module for resource action with functions around an Ecto schema and the Resource API boundary module.

  The goal and motivation is to encourage developers to write cleaner code in a more organized folder structure, enabling them to know in seconds all domains, resources, and actions used in a project. This  also contributes to reduce the technical debt via less complexity and clear boundaries between domains, resources and actions.

  ## Usage Examples

  The `scribe.gen.html` generator will generate files in both `lib/my_app_web/*`, `lib/my_app/*` and `tests/*` folders with the same hierarchy structure.

  For example, to create a fictitious online shop app you may start with this command:

  ```
  mix scribe.gen.html Catalog Category categories name:string desc:string
  ```

  The first argument is the domain name followed by the resource name and its plural name, which is also used as the schema table name. The second argument, `Catalog`, is the resource's schema. A schema is an Elixir module responsible for mapping database fields into an Elixir struct. The `Catalog` schema above specifies two fields with their respective colon-delimited data types: `name:string` and `desc:string`. See `mix phx.gen.schema` for more information on attributes.

  By default the command will generate some default actions for each resource on
  a domain: `["list", "new", "read", "edit", "create", "update", "delete"]`.

  We can also pass as many custom actions as we want with the flag `--actions`:

  ```
  mix scribe.gen.html Catalog Product products name:string desc:string --actions import,export
  ```

  When don't need to use the default actions, then just pass the flag `--no-default-actions`:

  ```
  mix scribe.gen.html Warehouse Stock stocks product_id:integer quantity:integer --actions import,export --no-default-actions
  ```

  ### The folder structure

  By using the previous command examples we get this folder structure:

  ```text
  $ tree -d -L 4 lib/my_app_web

  lib/my_app_web
  ├── components
  │   └── layouts
  ├── controllers
  │   └── page_html
  └── domains
      ├── catalog
      │   ├── category
      │   │   ├── create
      │   │   ├── delete
      │   │   ├── edit
      │   │   ├── export
      │   │   ├── import
      │   │   ├── list
      │   │   ├── new
      │   │   ├── read
      │   │   └── update
      │   └── product
      │       ├── create
      │       ├── delete
      │       ├── edit
      │       ├── export
      │       ├── import
      │       ├── list
      │       ├── new
      │       ├── read
      │       └── update
      └── warehouse
          └── stock
              ├── edit
              ├── export
              ├── import
              ├── list
              ├── new
              └── read

  ```

  This generator adds the following files to `lib/`:

    * a controller per resource action at `lib/my_app_web/domains/domain/resource/action`.
    * default HTML templates per resource action in `lib/my_app_web/domains/domain/resource/action`.
    * an HTML view per resource in `lib/my_app_web/domains/domain/resource`.
    * a schema per resource in `lib/my_app/domains/domain/resource`.
    * a module per resource action in `lib/my_app/domains/domain/resource/action`
    * a resource API boundary module in `lib/my_app/domains/domain`.

  Additionally, this generator creates the following files:

    * a migration for the schema in `priv/repo/migrations`.
    * a controller test module per resource action in `test/my_app_web/domains/domain/resource/action`.
    * a a module per resource action in `test/my_app/domains/domain/resource/action`.
    * a context test helper module in `test/support/fixtures/[resource_name]_fixtures.ex`.


  ## The API Boundary

  To prevent direct access between resources of the same domain or cross domains
  an API is provided for each Resource to act as a boundary that MUST never be
  crossed to not couple domains and resources via the internal implementation.

  This enables developers to change the internal implementation of any action of
  a Resource knowing that the only caller is the resource API boundary.

  The API boundary for each resource in a domain is located at the root of the
  domain folder. For example: `MyApp.Catalog.CategoryAPI`, which can be
  found at `lib/my_app/catalog/category_api.ex`.

  Developers need to treat anything inside a resource as private, which for the
  Catalog domain (exemplified above) means to not access any module inside
  `lib/my_app/catalog/category/*`.


  ## The Schema

  The schema is responsible for mapping the database fields into an
  Elixir struct. A migration file for the repository will also be generated.

  The schema can be found at `lib/my_app/catalog/category.ex` and it's
  considered public, meaning you can use it from anywhere in `my_app`.

  ### Generating without a schema

  In some cases, you may wish to bootstrap the domain and its resources without
  any logic to access the schema, leaving the internal implementation to
  yourself. Use the `--no-schema` flag to accomplish this.

  For example:

  ```
  mix scribe.gen.html Accounts Company companies --no-schema
  ```

  ## The Database Table

  By default, the table name for the migration and schema will be
  the plural name provided for the resource. To customize this value,
  a `--table` option may be provided.

  For example:

  ```
  mix scribe.gen.html Accounts User users --table cms_users
  ```

  ## Binary ID by Default

  By default the generated migration uses `binary_id` for schema's primary key
  and its references. To not use it you may pass the flag `--no-binary-id`.

  For example:

  ```
  mix scribe.gen.html Accounts AdminUser admin_users --no-binary-id
  ```

  >### Security Implications of `--no-binary-id` {: .warning}
  >* For security reasons is **strongly** discouraged the use of
  >  regular numeric ids.
  >* Numeric IDs allows an attacker to easily enumerate all resources by
  >  incrementing or decrementing the id by one, when proper access controls mechanisms
  >  aren't working as expected or may even be absent. This is the top one
  >  vulnerability in OWASP AP TOP 10 2023, named as BOLA (Broken Object
  >  Level Authorization). Don't assume this will not happen in your code
  >  base.


  ## Default options

   This generator uses default options provided in the `:generators` configuration of your application in the same way `phx.gen.html` does, except for `binary-id`, which is ignored and always set to `true` by `scribe.gen.domain`. This is a design choice to force the developer to opt-out of a secure default, instead of defaulting to a less secure default, which would require the developer to be aware why it isn't secure and to not forget to opt-in to the secure alternative. As a Scribe developer you MUST strive to always implement security in your code as an opt-out, not as an opt-in feature.


  Read the documentation for `phx.gen.html` and `phx.gen.schema` for more information on attributes.

  """
  use Mix.Task

  alias Mix.Phoenix.{Context, Schema}
  alias Mix.Tasks.Scribe.Gen
  alias ElixirScribe.DomainGenerator.ResourceAPI

  alias ElixirScribe.MixGeneratorAPI
  alias ElixirScribe.DomainGenerator.Resource.ParseArgs.ParseArgsResource

  @doc false
  def run(args) do
    if Mix.Project.umbrella?() do
      Mix.raise(
        "mix scribe.gen.html must be invoked from within your *_web application root directory"
      )
    end
dbg(args)
    {valid_args, opts, _invalid_args} = args |> ResourceAPI.parse_args() |> dbg()

    valid_args
    |> ResourceAPI.build_context!(opts, ParseArgsResource)
    |> generate_new_files()
    |> inject_routes()
    |> print_shell_instructions()
  end

  defp generate_new_files(%Context{} = context) do
    paths = ElixirScribe.default_base_template_paths()
    files = files_to_be_generated(context)

    prompt_for_conflicts(context, files)

    binding = ElixirScribe.build_binding(context) |> Keyword.merge(inputs: inputs(context.schema))

    MixGeneratorAPI.copy_from(paths, ".", binding, files)

    ResourceAPI.generate_new_files(context, prompt_for_conflicts?: false)

    context
  end

  defp prompt_for_conflicts(context, files) do
    ResourceAPI.files_to_generate(context)
    |> Kernel.++(files)
    |> MixGeneratorAPI.prompt_for_conflicts()
  end

  @doc false
  def files_to_be_generated(%Context{schema: schema, context_app: _context_app} = context) do
    singular = schema.singular
    # web_prefix = Mix.Phoenix.web_path(context_app)
    # test_prefix = Mix.Phoenix.web_test_path(context_app)
    # web_path = to_string(schema.web_path)
    # controller_pre = Path.join([web_prefix, "domains", context.basename])
    # domains_path = ElixirScribe.get_domains_path(context, :lib_web)
    resource_path = ElixirScribe.get_resource_path(context, :lib_web)
    test_pre = ElixirScribe.get_resource_path(context, :test_web)

    # domains_test_path = ElixirScribe.get_domains_path(context, :test_web)
    # test_pre = Path.join([domains_test_path, resource])
    dbg(test_pre)
    # test_pre = Path.join([test_prefix, "domains", web_path])
    # test_pre = Path.join([test_prefix, web_path])

    controller_template_path = ElixirScribe.default_controller_template_path()
    controller_test_template_path = ElixirScribe.default_controller_test_template_path()
    html_template_path = MixGeneratorAPI.build_path_html_template(context)

    resource_form_source = Path.join(html_template_path, "resource_form.html.heex")
    resource_form_target = Path.join([resource_path, "#{singular}_form.html.heex"])
    not_used_action = ""

    files = [
      {:eex, resource_form_source, resource_form_target, not_used_action},
      {:eex, Path.join(html_template_path, "html.ex"),
       Path.join([resource_path, "#{singular}_html.ex"]), not_used_action}
    ]

    default_actions = MixGeneratorAPI.build_actions_from_options(context.opts)

    files =
      for action <- default_actions, reduce: files do
        files ->
          # target = ElixirScribe.get_resource_action_file(context, action, "_controller.ex", :web)
          # source_filename =
          #   ElixirScribe.MixGeneratorAPI.build_template_action_filename(action, "controller.ex", "_")

          # source = Path.join(controller_template_path, source_filename)

          # file = {:eex, source, target, action}
          # [file | files]
          build_file_to_be_generated(
            files,
            context,
            action,
            "_",
            controller_template_path,
            "controller.ex",
            :lib_web
          )
      end

    html_actions = ElixirScribe.default_html_actions()

    files =
      for html_action <- html_actions, reduce: files do
        files ->
          if html_action in default_actions do
            build_file_to_be_generated(
              files,
              context,
              html_action,
              ".",
              html_template_path,
              "html.heex",
              :lib_web
            )
          else
            files
          end
      end

    for action <- default_actions, reduce: files do
      files ->
        build_file_to_be_generated(
          files,
          context,
          action,
          "_",
          controller_test_template_path,
          "controller_test.exs",
          :test_web
        )
    end
  end

  defp build_file_to_be_generated(
         files,
         context,
         action,
         action_suffix,
         source_base_dir,
         filename,
         type
       ) do
    file =
      build_action_file(
        context,
        action,
        action_suffix,
        source_base_dir,
        filename,
        type
      )

    [file | files]
  end

  defp build_action_file(
         context,
         action,
         action_suffix,
         source_base_dir,
         filename,
         type
       ) do
    source_filename =
      ElixirScribe.MixGeneratorAPI.build_template_action_filename(action, filename, action_suffix)

    source = Path.join(source_base_dir, source_filename)


    # resource =
    #   (action in ElixirScribe.default_plural_actions() && context.schema.plural) ||
    #     context.schema.singular

    # resource_filename = "#{action}_#{resource}#{action_suffix}#{filename}"
    # target = Path.join([root_dir, context.schema.singular, "#{action}", resource_filename])
    resource_filename_suffix = "#{action_suffix}#{filename}"
    target = ElixirScribe.get_resource_action_file(context, action, resource_filename_suffix, type)

    {:eex, source, target, action}
  end

  @doc false
  def inject_routes(%Context{context_app: ctx_app} = context) do
    router_file_path = Mix.Phoenix.web_path(ctx_app) |> Path.join("router.ex")
    router_scope = MixGeneratorAPI.scope_routes(context)

    MixGeneratorAPI.inject_content_before_final_end(router_scope, router_file_path)

    context
  end

  @doc false
  def print_shell_instructions(%Context{schema: schema, context_app: ctx_app} = context) do
    router_file_path = Mix.Phoenix.web_path(ctx_app) |> Path.join("router.ex")
    router_scope = MixGeneratorAPI.scope_routes(context)

    Mix.shell().info("""

     Your #{schema.web_namespace} :browser scope in #{router_file_path} should now look like this:
     #{router_scope}
    """)

    if context.generate?, do: Gen.Domain.print_shell_instructions(context)
  end

  @doc false
  def inputs(%Schema{} = schema) do
    schema.attrs
    |> Enum.reject(fn {_key, type} -> type == :map end)
    |> Enum.map(fn
      {key, :integer} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" />)

      {key, :float} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" step="any" />)

      {key, :decimal} ->
        ~s(<.input field={f[#{inspect(key)}]} type="number" label="#{label(key)}" step="any" />)

      {key, :boolean} ->
        ~s(<.input field={f[#{inspect(key)}]} type="checkbox" label="#{label(key)}" />)

      {key, :text} ->
        ~s(<.input field={f[#{inspect(key)}]} type="text" label="#{label(key)}" />)

      {key, :date} ->
        ~s(<.input field={f[#{inspect(key)}]} type="date" label="#{label(key)}" />)

      {key, :time} ->
        ~s(<.input field={f[#{inspect(key)}]} type="time" label="#{label(key)}" />)

      {key, :utc_datetime} ->
        ~s(<.input field={f[#{inspect(key)}]} type="datetime-local" label="#{label(key)}" />)

      {key, :naive_datetime} ->
        ~s(<.input field={f[#{inspect(key)}]} type="datetime-local" label="#{label(key)}" />)

      {key, {:array, _} = type} ->
        ~s"""
        <.input
          field={f[#{inspect(key)}]}
          type="select"
          multiple
          label="#{label(key)}"
          options={#{inspect(default_options(type))}}
        />
        """

      {key, {:enum, _}} ->
        ~s"""
        <.input
          field={f[#{inspect(key)}]}
          type="select"
          label="#{label(key)}"
          prompt="Choose a value"
          options={Ecto.Enum.values(#{inspect(schema.module)}, #{inspect(key)})}
        />
        """

      {key, _} ->
        ~s(<.input field={f[#{inspect(key)}]} type="text" label="#{label(key)}" />)
    end)
  end

  defp default_options({:array, :string}),
    do: Enum.map([1, 2], &{"Option #{&1}", "option#{&1}"})

  defp default_options({:array, :integer}),
    do: Enum.map([1, 2], &{"#{&1}", &1})

  defp default_options({:array, _}), do: []

  defp label(key), do: Phoenix.Naming.humanize(to_string(key))

  @doc false
  def indent_inputs(inputs, column_padding) do
    columns = String.duplicate(" ", column_padding)

    inputs
    |> Enum.map(fn input ->
      lines = input |> String.split("\n") |> Enum.reject(&(&1 == ""))

      case lines do
        [] ->
          []

        [line] ->
          [columns, line]

        [first_line | rest] ->
          rest = Enum.map_join(rest, "\n", &(columns <> &1))
          [columns, first_line, "\n", rest]
      end
    end)
    |> Enum.intersperse("\n")
  end
end
