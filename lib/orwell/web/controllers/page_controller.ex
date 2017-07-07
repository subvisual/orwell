defmodule Orwell.Web.PageController do
  use Orwell.Web, :controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    if user do
      redirect conn, to: post_path(conn, :index)
    else
      render(conn, "index.html")
    end
  end
end
