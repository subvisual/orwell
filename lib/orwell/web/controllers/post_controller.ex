defmodule Orwell.Web.PostController do
  use Orwell.Web, :authenticated_controller

  alias Orwell.Post

  def new(conn, _params) do
    conn
    |> assign(:markdown, "")
    |> render("new.html")
  end

  def show(conn, %{"id" => id} = _params) do
    config = conn.assigns[:github_config]
    resp = id |> Orwell.GitHub.post(config)

    case resp do
      {:ok, post} ->
        conn
        |> assign(:markdown, post)
        |> render("show.html")
      {:error, reason} ->
        conn
        |> put_status(404)
        |> put_flash(:error, reason)
        |> assign(:markdown, "")
        |> render("show.html")
    end
  end

  def index(conn, _params) do
    config = conn.assigns[:github_config]

    case Orwell.GitHub.posts(config) do
      {:ok, posts} ->
        conn
        |> assign(:posts, posts)
        |> render("index.html")
      {:error, reason} ->
        conn
        |> put_status(500)
        |> put_flash(:error, reason)
        |> assign(:posts, [])
        |> render("index.html")
    end
  end

  def new(conn, _params) do
    post = Post.new()

    conn
    |> assign(:post, post)
    |> render("new.html")
  end

  def create(conn, %{"post" => post_form_params}) do
    github_config = conn.assigns[:github_config]

    post = post_form_params
           |> Map.merge(generated_post_params(github_config))
           |> Post.from_params

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

  defp generated_post_params(github_config) do
    {:ok, posts} = Orwell.GitHub.posts(github_config)

    current_max_id = posts
         |> Stream.map(&Map.get(&1, "id"))
         |> Enum.max

    %{"id" => current_max_id + 1}
  end
end
