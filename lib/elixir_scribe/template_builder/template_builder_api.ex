defmodule ElixirScribe.TemplateBuilderAPI do
  @moduledoc false

  alias ElixirScribe.TemplateBuilder.BuildFilenameActionTemplateContract
  alias ElixirScribe.Generator.Domain.DomainContract
  alias ElixirScribe.TemplateBuilder.Template.Conflicts.MixPromptFileConflicts
  alias ElixirScribe.TemplateBuilder.Template.Copy.CopyFile
  alias ElixirScribe.TemplateBuilder.Template.Inject.InjectContentBeforeFinalEnd
  alias ElixirScribe.TemplateBuilder.Template.Inject.InjectEexBeforeFinalEnd
  alias ElixirScribe.TemplateBuilder.Route.Scope.ScopeActionRoutes
  alias ElixirScribe.TemplateBuilder.Module.BuildName.BuildAbsoluteModuleName
  alias ElixirScribe.TemplateBuilder.Module.BuildName.BuildModuleActionName
  alias ElixirScribe.TemplateBuilder.Module.BuildName.BuildAbsoluteModuleActionName
  alias ElixirScribe.TemplateBuilder.Module.BuildName.BuildAbsoluteModuleActionNameAliases
  alias ElixirScribe.TemplateBuilder.Options.BuildEmbedTemplates.BuildModuleEmbedTemplates
  alias ElixirScribe.TemplateBuilder.Template.BuildFilename.BuildFilenameActionTemplate
  alias ElixirScribe.TemplateBuilder.Template.BuildPath.BuildPathHtmlTemplate
  alias ElixirScribe.TemplateBuilder.Template.BuildBinding.BuildBindingTemplate
  alias ElixirScribe.TemplateBuilder.Template.RebuildBinding.RebuildBindingTemplate


  def build_embeded_templates(), do: BuildModuleEmbedTemplates.build()

  def build_absolute_module_action_name(%DomainContract{} = contract, action, opts) when is_list(opts),
    do: BuildAbsoluteModuleActionName.build(contract, action, opts)

  def build_absolute_module_action_name_aliases(%DomainContract{} = contract, opts) when is_list(opts),
    do: BuildAbsoluteModuleActionNameAliases.build(contract, opts)

  def build_absolute_module_name(%DomainContract{} = contract, opts) when is_list(opts),
    do: BuildAbsoluteModuleName.build(contract, opts)

  def build_module_action_name(%DomainContract{} = contract, action) when is_binary(action),
    do: BuildModuleActionName.build(contract, action)

    def scope_routes(%DomainContract{} = contract), do: ScopeActionRoutes.scope(contract)


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





  def build_template_action_filename(%BuildFilenameActionTemplateContract{} = contract),
    do: BuildFilenameActionTemplate.build(contract)

  def build_path_html_template(%DomainContract{} = contract), do: BuildPathHtmlTemplate.build(contract)

  def build_binding_template(%DomainContract{} = contract), do: BuildBindingTemplate.build(contract)

  def rebuild_binding_template(binding, action, opts), do: RebuildBindingTemplate.rebuild(binding, action, opts)
end
