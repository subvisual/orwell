defmodule Orwell.Web.PostController do
  use Orwell.Web, :controller

  alias Orwell.Post

  plug Guardian.Plug.EnsureAuthenticated, handler: Orwell.Web.AuthController

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

  def new(conn, _params) do
    post = Post.new()

    conn
    |> assign(:post, post)
    |> render("new.html")
  end

  def create(conn, %{"post" => post_params}) do
    post = Post.from_params(post_params)

    if Post.valid?(post) do
      conn
      |> put_flash(:info, "Post is valid, unfortunately, our code monkeys haven't implemented this feature yet. Tough luck")
      |> assign(:post, post)
      |> render("new.html")
    else

      conn
      |> put_flash(:error, "Whoops. You messed something up.")
      |> assign(:post, post)
      |> render("new.html")
    end
  end
end
