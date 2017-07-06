defmodule Orwell.Web.PageController do
  use Orwell.Web, :controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    conn
    |> assign(:user, user)
    |> render("index.html")
  end
end
