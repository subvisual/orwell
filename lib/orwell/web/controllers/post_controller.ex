defmodule Orwell.Web.PostController do
  use Orwell.Web, :controller

  alias Orwell.Post

  def new(conn, _params) do
    conn
    |> assign(:markdown, "")
    |> render("new.html")
  end

  def create(conn, %{"post" => %{"title" => title, "body" => body}}) do
    md = Post.new(title, body) |> Post.full_file

    conn
    |> assign(:markdown, md)
    |> render("new.html")
  end
end
