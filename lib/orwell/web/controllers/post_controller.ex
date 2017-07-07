defmodule Orwell.Web.PostController do
  use Orwell.Web, :controller

  alias Orwell.Post

  plug Guardian.Plug.EnsureAuthenticated, handler: Orwell.Web.AuthController

  def new(conn, _params) do
    conn
    |> assign(:markdown, "")
    |> render("new.html")
  end

  def index(conn, _params) do
    case Orwell.GitHub.posts() do
      {:ok, posts} ->
        conn
        |> assign(:posts, posts)
        |> render("index.html")
      {:error, _reason} ->
        conn
        |> put_status(500)
        |> put_flash(:error, "Something went wrong")
        |> render("/")
    end
  end

  def create(conn, %{"post" => %{"title" => title, "body" => body}}) do
    md = Post.new(title, body) |> Post.full_file

    conn
    |> assign(:markdown, md)
    |> render("new.html")
  end
end
