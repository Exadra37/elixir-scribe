defmodule ElixirScribe.MixGenerator.AppApiContract do
  @moduledoc false

  import Norm
  alias Mix.Phoenix.Context

  defmodule BuildResourceActionFilePathContract do
    @keys %{
      required: [:action, :context, :file_extension, :path_type],
      optional: [file_type: ".ex"]
    }

    use ElixirScribe.Behaviour.TypedContract, keys: @keys

    @impl true
    def type_spec(), do: schema(%__MODULE__{
        action: is_binary() |> spec(),
        context: context?() |> spec(),
        file_extension: app_file_extension?() |> spec(),
        file_type: app_file_type?() |> spec(),
        path_type: app_path_type?() |> spec(),
      })

    defp context?(%Context{}), do: true
    defp context?(_context), do: false

    # @resource_actions ElixirScribe.resource_actions()
    # defp resource_action?(action) when action in @resource_actions, do: true
    # defp resource_action?(_action), do: false

    @app_file_extensions ElixirScribe.app_file_extensions()
    defp app_file_extension?(path_type) when path_type in @app_file_extensions, do: true
    defp app_file_extension?(_action), do: false

    @app_file_types ElixirScribe.app_file_types()
    defp app_file_type?(path_type) when path_type in @app_file_types, do: true
    defp app_file_type?(_action), do: false

    @app_path_types ElixirScribe.app_path_types()

    defp app_path_type?(path_type) when path_type in @app_path_types, do: true
    defp app_path_type?(_action), do: false
  end
end
