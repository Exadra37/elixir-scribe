defmodule ElixirScribe.TemplateBuilder.Template.RebuildBinding.RebuildBindingTemplate do
  @moduledoc false

  alias ElixirScribe.TemplateBuilderAPI
  alias ElixirScribe.Utils.StringAPI

  def rebuild(binding, action, opts) when is_list(binding) and is_binary(action) and is_list(opts) do
    contract = Keyword.get(binding, :contract)

    Keyword.merge(binding,
      action: action,
      action_first_word: StringAPI.first_word(action),
      action_capitalized: StringAPI.capitalize(action),
      action_human_capitalized: StringAPI.human_capitalize(action),
      module_action_name:
        TemplateBuilderAPI.build_module_action_name(contract, action),
      absolute_module_action_name:
        TemplateBuilderAPI.build_absolute_module_action_name(contract, action, opts)
    )
  end
end
