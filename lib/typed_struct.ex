defmodule TypedStruct do
  defmacro __using__(_) do
    quote do
      import TypedStruct, only: [typedstruct: 1]
    end
  end

  defmacro typedstruct(do: ast) do
    fields_ast =
      case ast do
        {:__block__, [], fields} -> fields
        field -> [field]
      end

    fields_data = Enum.map(fields_ast, &get_field_data/1)

    enforced_fields =
      for field <- fields_data, field.enforced? do
        field.name
      end

    typespecs =
      Enum.map(fields_data, fn
        %{name: name, typespec: typespec, enforced?: true} -> {name, typespec}
        %{name: name, typespec: typespec} ->
          {
            name,
            {:|, [], [typespec, nil]}
          }
      end)

    fields =
      for %{name: name, default: default} <- fields_data do
        {name, default}
      end

    quote location: :keep do
      @type t :: %__MODULE__{unquote_splicing(typespecs)}
      @enforce_keys unquote(enforced_fields)
      defstruct unquote(fields)
    end

    # ast = ast(typespecs)

    # quote do
    #   (fn -> unquote(ast) |> dbg() end).()
    # end
  end

  # defp ast(typespecs) do
  #   quote location: :keep do
  #     @type t :: %__MODULE__{unquote_splicing(typespecs)}
  #   end
  # end

  defp get_field_data({:field, _meta, [name, typespec]}) do
    get_field_data({:field, [], [name, typespec, []]})
  end
  defp get_field_data({:field, _meta, [name, typespec, opts]}) do
    default = Keyword.get(opts, :default)
    enforced? = Keyword.get(opts, :enforced?, false)

    %{
      name: name,
      typespec: typespec,
      default: default,
      enforced?: enforced?
    }
  end
end
