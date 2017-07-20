defmodule Orwell.Web.PostController do
  use Orwell.Web, :authenticated_controller

  alias Orwell.Post

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
    current_user = Guardian.Plug.current_resource(conn)
    github_config = conn.assigns[:github_config]
    id = Orwell.GitHub.next_post_id(github_config)
    path =
      post_form_params["title"]
      |> Orwell.GitHub.Blog.to_filename(id)
      |> Orwell.GitHub.Blog.post_url

    post = post_form_params
           |> Map.put("id", id)
           |> Map.put("author", current_user.github_uid)
           |> Map.put("date", Post.formatted_utc_today())
           |> Map.put("path", path)
           |> Post.from_params

    if Post.valid?(post) do
      {:ok, url} = create_post(post, github_config)

      conn
      |> put_flash(:info, "Pull Request created! Check it at: #{url}")
      |> assign(:post, post)
      |> render("new.html")
    else

      conn
      |> put_flash(:error, "Whoops. You messed something up.")
      |> assign(:post, post)
      |> render("new.html")
    end
  end

  defp create_post(post, config) do
    filename = Orwell.GitHub.Blog.to_filename(post.title, post.id)
    full_file = Post.full_file(post)

    {:ok, _url} = Orwell.GitHub.commit(filename, full_file, config)

    Orwell.GitHub.pull_request(post.title, filename, config)
  end
end
