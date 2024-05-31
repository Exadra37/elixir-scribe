defmodule ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract do

  import Norm
  alias Mix.Phoenix.Context

  @enforce_keys [:action, :context, :file_extension, :path_type]
  @optional_keys [:file_type]
  @all_keys @enforce_keys ++ @optional_keys

  defstruct @all_keys

  def s(), do: schema(%__MODULE__{
      action: resource_action?() |> spec(),
      context: context?() |> spec(),
      file_extension: app_file_extension?() |> spec(),
      file_type: app_file_type?() |> spec(),
      path_type: app_path_type?() |> spec(),
    })

  def new(attrs) do
    struct(__MODULE__, attrs)
    |> conform(__MODULE__.s())
  end

  def new!(attrs) do
    struct(__MODULE__, attrs)
    |> conform!(__MODULE__.s())
  end

  defp context?(%Context{}), do: true
  defp context?(_context), do: false

  @resource_actions ElixirScribe.resource_actions()
  defp resource_action?(action) when action in @resource_actions, do: true
  defp resource_action?(_action), do: false

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


# defmodule ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilePathContract do
#   @moduledoc """
#   The API Contract struct to use when invoking `AppApi.build_resource_action_filename/1`.

#   ## Usage Example:

#       iex> %{context: %Mix.Phoenix.Context{}, action: "list", suffix: ".ex"} |> AppApiContract.BuildResourceActionFilenameContract.new() |> AppApi.build_resource_action_filename()
#   """

#   alias Mix.Phoenix.Context
#   alias __MODULE__

#   use Drops.Contract

#   @enforce_keys [:context, :action, :suffix, :type]

#   defstruct @enforce_keys

#   @actions ElixirScribe.resource_actions()

#   schema do
#     %{
#       # required(:context) => Context,
#       required(:context) => map(),
#       # required(:context) => type(:struct, [Context]),
#       required(:action) => string(includes?: @actions),
#       required(:suffix) => string(:filled?),
#       required(:type) => type(:atom, includes?: [:lib_core, :lib_test]),
#     }
#   end

#   @doc false
#   def new(%{context: %Context{}} = attrs) when is_map(attrs) do
#     case conform(attrs) do
#       {:ok, attrs} ->
#         struct(__MODULE__, attrs)

#       error ->
#         error
#     end
#   end
# end


# defmodule ElixirScribe.MixGenerator.AppApiContract.BuildResourceActionFilenameContract do
#   @moduledoc """
#   The API Contract struct to use when invoking `AppApi.build_resource_action_filename/1`.

#   ## Usage Example:

#       iex> %{context: %Mix.Phoenix.Context{}, action: "list", suffix: ".ex"} |> AppApiContract.BuildResourceActionFilenameContract.new() |> AppApi.build_resource_action_filename()
#   """

#   alias Mix.Phoenix.Context

#   # defmodule BuildResourceActionFilenameContract do
#     # @moduledoc """
#     # Some module docs

#     # some functions
#     # """
#     use Drops.Contract

#     @enforce_keys [:context, :action, :suffix]

#     defstruct @enforce_keys

#     schema do
#       %{
#         required(:context) => map(),
#         required(:action) => string(:filled?),
#         required(:suffix) => string(:filled?),
#       }
#     end

#     @doc false
#     def new(%{context: %Context{}} = attrs) when is_map(attrs) do
#       case conform(attrs) do
#         {:ok, attrs} ->
#           struct(__MODULE__, attrs)

#         error ->
#           error
#       end
#     end
#   # end
# end
