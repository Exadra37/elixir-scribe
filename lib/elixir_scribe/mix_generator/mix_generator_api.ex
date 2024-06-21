defmodule ElixirScribe.MixGeneratorAPI do
  @moduledoc false

  alias Mix.Scribe.Context
  alias ElixirScribe.MixGenerator.Template.Conflicts.MixPromptFileConflicts
  alias ElixirScribe.MixGenerator.Template.Copy.CopyFile
  alias ElixirScribe.MixGenerator.Template.Inject.InjectContentBeforeFinalEnd
  alias ElixirScribe.MixGenerator.Template.Inject.InjectEexBeforeFinalEnd
  alias ElixirScribe.MixGenerator.Route.Scope.ScopeActionRoutes
  alias ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleName
  alias ElixirScribe.MixGenerator.Module.BuildName.BuildModuleActionName
  alias ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionName
  alias ElixirScribe.MixGenerator.Module.BuildName.BuildAbsoluteModuleActionNameAliases
  alias ElixirScribe.MixGenerator.Options.BuildActions.BuildActionsFromOptions
  alias ElixirScribe.MixGenerator.Options.BuildEmbedTemplates.BuildModuleEmbedTemplates
  alias ElixirScribe.MixGenerator.Options.MaybeAddBinaryId.MaybeAddBinaryIdOption
  alias ElixirScribe.MixGenerator.Template.BuildFilename.BuildFilenameActionTemplate
  alias ElixirScribe.MixGenerator.Template.BuildPath.BuildPathHtmlTemplate
  alias ElixirScribe.MixGenerator.Template.BuildBinding.BuildBindingTemplate
  alias ElixirScribe.MixGenerator.Template.RebuildBinding.RebuildBindingTemplate

  @doc """
  Prompts to continue if any files exist.
  """
  def prompt_for_conflicts(files) when is_list(files), do: MixPromptFileConflicts.prompt(files)

  @doc """
  Copies files from source dir to target dir according to the given map.

  Files are evaluated against EEx according to the given binding.
  """
  def copy_from(apps, source_dir, binding, mapping) when is_list(mapping),
    do: CopyFile.copy_from(apps, source_dir, binding, mapping)

  def inject_content_before_final_end(content_to_inject, file_path),
    do: InjectContentBeforeFinalEnd.inject(content_to_inject, file_path)

  def inject_eex_before_final_end(content_to_inject, file_path, binding),
    do: InjectEexBeforeFinalEnd.inject(content_to_inject, file_path, binding)

  def scope_routes(%Context{} = context), do: ScopeActionRoutes.scope(context)

  def build_absolute_module_name(%Context{} = context, opts) when is_list(opts),
    do: BuildAbsoluteModuleName.build(context, opts)

  def build_module_action_name(%Context{} = context, action, opts) when is_list(opts),
    do: BuildModuleActionName.build(context, action, opts)

  def build_absolute_module_action_name(%Context{} = context, action, opts) when is_list(opts),
    do: BuildAbsoluteModuleActionName.build(context, action, opts)

  def build_absolute_module_action_name_aliases(%Context{} = context, opts) when is_list(opts),
    do: BuildAbsoluteModuleActionNameAliases.build(context, opts)

  def build_actions_from_options(opts) when is_list(opts), do: BuildActionsFromOptions.build(opts)

  def build_embeded_templates(), do: BuildModuleEmbedTemplates.build()

  def maybe_add_binary_id_option(args) when is_list(args),
    do: MaybeAddBinaryIdOption.maybe_add(args)

  def build_template_action_filename(action, action_suffix, file_type, file_extension),
    do: BuildFilenameActionTemplate.build(action, action_suffix, file_type, file_extension)

  def build_path_html_template(%Context{} = context), do: BuildPathHtmlTemplate.build(context)

  def build_binding_template(%Context{} = context), do: BuildBindingTemplate.build(context)

  def rebuild_binding_template(binding, action, opts), do: RebuildBindingTemplate.rebuild(binding, action, opts)
end
