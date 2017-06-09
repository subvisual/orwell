defmodule Orwell.Web.PostController do
  use Orwell.Web, :controller

  def new(conn, _params) do
    conn
    |> render("new.html")
  end

  def create(conn, _params) do
    conn
    |> put_flash(:info, "not yet implemented")
    |> redirect(to: post_path(conn, :new))
  end
end
