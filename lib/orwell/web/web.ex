defmodule Orwell.Web do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use Orwell.Web, :controller
      use Orwell.Web, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Orwell.Web
      import Plug.Conn
      import Orwell.Web.Router.Helpers
      import Orwell.Web.Gettext
    end
  end

  def authenticated_controller do
    quote do
      use Phoenix.Controller, namespace: Orwell.Web
      import Plug.Conn
      import Orwell.Web.Router.Helpers
      import Orwell.Web.Gettext

      plug Guardian.Plug.EnsureAuthenticated, handler: Orwell.Web.AuthController
      plug Orwell.Plug.GitHub
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/orwell/web/templates",
                        namespace: Orwell.Web

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Orwell.Web.Router.Helpers
      import Orwell.Web.ErrorHelpers
      import Orwell.Web.Gettext

      def current_user(conn) do
        Guardian.Plug.current_resource(conn)
      end
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Orwell.Web.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
