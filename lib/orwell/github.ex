defmodule Orwell.GitHub do
  alias Orwell.GitHub

  @spec posts(Github.Config.t) :: {atom, any}
  def posts(config) do
    GitHub.Trees.find_recursive("master", config) |> traverse_tree
  end

  @spec traverse_tree({Integer, map}) :: {atom, String.t}
  defp traverse_tree({_status, %{"message" => reason}}), do: {:error, reason}

  @spec traverse_tree(map) :: {atom, String.t}
  defp traverse_tree(%{"tree" => tree}) do
    posts =
      tree
      |> Stream.map(& Map.take(&1, ["path", "sha"]))
      |> Stream.filter(&String.starts_with?(&1["path"], GitHub.Blog.posts_dir()))
      |> Stream.filter(&String.ends_with?(&1["path"], ".md"))
      |> Stream.map(& Map.put(&1, "name", GitHub.Blog.titleize(&1["path"])))
      |> Enum.reverse

    {:ok, posts}
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
end
