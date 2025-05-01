defmodule BuddiesBackendWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use BuddiesBackendWeb, :controller
      use BuddiesBackendWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: BuddiesBackendWeb.Layouts]

      import Plug.Conn

      def changeset_error_to_string(changeset) do
        Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
          Enum.reduce(opts, msg, fn {key, value}, acc ->
            String.replace(acc, "%{#{key}}", _to_string(value))
          end)
        end)
        |> Enum.reduce("", fn {k, v}, acc ->
          joined_errors = Enum.join(v, "; ")
          "#{acc}#{k}: #{joined_errors}, "
        end)
      end

      defp _to_string(val) when is_list(val) do
        Enum.join(val, ",")
      end

      defp _to_string(val), do: to_string(val)

      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: BuddiesBackendWeb.Endpoint,
        router: BuddiesBackendWeb.Router,
        statics: BuddiesBackendWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/live_view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
