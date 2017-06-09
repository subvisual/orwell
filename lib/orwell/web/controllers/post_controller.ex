defmodule Orwell.Web.PostController do
  use Orwell.Web, :controller

  def new(conn, _params) do
    conn
    |> render("new.html")
  end
end
