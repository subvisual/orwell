defmodule Orwell.GitHub do
  alias Orwell.GitHub

  @spec posts(GitHub.Config.t) :: {atom, any}
  def posts(config) do
    GitHub.Trees.find_recursive("master", config) |> traverse_tree
  end

  @spec post(binary, GitHub.Config.t) :: {atom, binary}
  def post(id, config) do
    case GitHub.posts(config) do
      {:ok, posts} -> find_post(id, posts, config)
      {:error, _reason} = r -> r
    end
  end

  @spec commit(binary, binary, GitHub.Config.t) :: {atom, binary}
  def commit(filename, body, config) do
    create_branch(filename, config)

    path = filename |> GitHub.Blog.post_path
    body = %{
      message: commit_message(filename),
      content: body |> Base.encode64,
      branch: filename,
    }

    {status, response} = GitHub.Contents.create(path, body, config)
    case status do
      201 -> {:ok, response["commit"]["html_url"]}
      _ -> {:error, response["message"]}
    end
  end

  @spec pull_request(binary, binary, GitHub.Config.t) :: {atom, binary}
  def pull_request(title, branch, config) do
    body = %{
      title: title,
      head: branch,
      base: "master",
      maintainer_can_modify: true,
    }

    {status, response} = GitHub.Pulls.create(body, config)

    case status do
      201 -> {:ok, response["html_url"]}
      _ -> {:error, response["message"]}
    end
  end

  @spec find_post(binary, List, Config.t) :: {atom, binary}
  defp find_post(id, posts, config) do
    path =
      posts
      |> Enum.filter(&Regex.match?(~r/.*\/#{id}-[^\/]*.md/, &1["path"]))
      |> List.first
      |> Access.get("path")

    case GitHub.Contents.find(path, config) do
      %{"content" => content} -> {:ok, decode64(content)}
      {_status, response} -> {:error, response["message"]}
    end
  end

  @spec create_branch(binary, Config.t) :: Integer
  defp create_branch(name, config) do
    master = GitHub.References.find("heads/master", config)
    ref = "refs/heads/" <> name

    %{ref: ref, sha: master["object"]["sha"]}
    |> GitHub.References.create(config)
    |> elem(0)
  end

  # This is a temporary situation as in the feature we will want meaningful
  # updates. However, for now let's just hardcode a unique commit message.
  # It's not relevant whether it is a new file or an update since, for now,
  # we only support insertions.
  @spec commit_message(binary) :: String.t
  defp commit_message(filename),
    do: "Adds #{filename}"


  # Recursively traverses a tree, depending on the request's status code
  # While traversing, Markdown files inside the posts directory are filtered.
  # The Markdown assumption is important as any subdirectories would be
  # included otherwise.
  # After filtering the Markdown files, the file name is converted to
  # a titleized version.
  # Finally, a map composed of the path, the sha (to be able to identify the
  # post) and the titleized file name is returned
  @spec traverse_tree({Integer, map}) :: {atom, String.t}
  defp traverse_tree({_status, %{"message" => reason}}), do: {:error, reason}

  @spec traverse_tree(map) :: {atom, String.t}
  defp traverse_tree(%{"tree" => tree}) do
    posts =
      tree
      |> Stream.map(&Map.take(&1, ["path", "sha"]))
      |> Stream.filter(&String.starts_with?(&1["path"], GitHub.Blog.posts_dir()))
      |> Stream.filter(&String.ends_with?(&1["path"], ".md"))
      |> Stream.map(&Map.put(&1, "name", GitHub.Blog.titleize(&1["path"])))
      |> Stream.map(&Map.put(&1, "id", GitHub.Blog.post_id(&1["path"])))
      |> Enum.reverse

    {:ok, posts}
  end

  # GitHub annoyingly includes \n between the encoded lines
  # So we must replace them in order to retrieve the file contents
  @spec decode64(String.t) :: String.t
  defp decode64(encoded) do
    {:ok, decoded} =
      encoded
      |> String.replace("\n", "")
      |> Base.decode64

    decoded |> String.trim
  end
end
