defmodule ElixirScribe.Mix.Generator.CopyFile.CopyFileGenerator do
  @moduledoc false

  alias ElixirScribe.TemplateBindingAPI

  # All functions were copied from the Phoenix Framework, but only modified `copy/4`

  @doc false
  def copy(apps_and_paths, source_dir, binding, mapping) when is_list(mapping) do
    dbg(apps_and_paths)
    dbg(source_dir)
    dbg(mapping)

    roots = Enum.map(apps_and_paths, &to_app_source(&1, source_dir))

    binding =
      Keyword.merge(binding,
        maybe_heex_attr_gettext: &maybe_heex_attr_gettext/2,
        maybe_eex_gettext: &maybe_eex_gettext/2
      )

    for {format, file_type, source_file_path, target, action} <- mapping do
      binding = TemplateBindingAPI.rebuild_binding_template(binding, action, file_type: file_type)

      source =
        Enum.find_value(roots, fn root ->
          dbg(root)
          source = Path.join(root, source_file_path)
          if File.exists?(source), do: source
        end) || raise "could not find #{source_file_path} in any of the sources"

      binding =
        Keyword.merge(binding,
          action: action,
          action_capitalized: String.capitalize(action)
        )

      case format do
        :text ->
          Mix.Generator.create_file(target, File.read!(source))

        :eex ->
          Mix.Generator.create_file(target, EEx.eval_file(source, binding))

        :new_eex ->
          if File.exists?(target) do
            :ok
          else
            Mix.Generator.create_file(target, EEx.eval_file(source, binding))
          end
      end
    end
  end

  defp to_app_source(path, source_dir) when is_binary(path),
    do: Path.join(path, source_dir)

  defp to_app_source(app, source_dir) when is_atom(app),
    do: Application.app_dir(app, source_dir)

  # In the context of a HEEx attribute value, transforms a given message into a
  # dynamic `gettext` call or a fixed-value string attribute, depending on the
  # `gettext?` parameter.
  #
  # ## Examples
  #
  #     iex> ~s|<tag attr=#{maybe_heex_attr_gettext("Hello", true)} />|
  #     ~S|<tag attr={gettext("Hello")} />|
  #
  #     iex> ~s|<tag attr=#{maybe_heex_attr_gettext("Hello", false)} />|
  #     ~S|<tag attr="Hello" />|
  defp maybe_heex_attr_gettext(message, gettext?) do
    if gettext? do
      ~s|{gettext(#{inspect(message)})}|
    else
      inspect(message)
    end
  end

  # In the context of an EEx template, transforms a given message into a dynamic
  # `gettext` call or the message as is, depending on the `gettext?` parameter.
  #
  # ## Examples
  #
  #     iex> ~s|<tag>#{maybe_eex_gettext("Hello", true)}</tag>|
  #     ~S|<tag><%= gettext("Hello") %></tag>|
  #
  #     iex> ~s|<tag>#{maybe_eex_gettext("Hello", false)}</tag>|
  #     ~S|<tag>Hello</tag>|
  defp maybe_eex_gettext(message, gettext?) do
    if gettext? do
      ~s|<%= gettext(#{inspect(message)}) %>|
    else
      message
    end
  end
end
