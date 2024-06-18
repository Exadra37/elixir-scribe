defmodule ElixirScribe.MixGenerator.Template.RebuildBinding.RebuildBindingTemplate do
  @moduledoc false

  alias ElixirScribe.MixGeneratorAPI
  alias ElixirScribe.Utils.StringAPI

  @doc false
  def rebuild(binding, action) when is_list(binding) and is_binary(action) do
    context = Keyword.get(binding, :context)

    Keyword.merge(binding,
      action: action,
      action_first_word: StringAPI.first_word(action),
      action_capitalized: StringAPI.capitalize(action),
      action_human_capitalized: StringAPI.human_capitalize(action),
      module_action_name:
        MixGeneratorAPI.build_module_action_name(context, action, from_schema: true),
      absolute_module_action_name:
        MixGeneratorAPI.build_absolute_module_action_name(context, action, from_schema: true)
    )
  end
end
