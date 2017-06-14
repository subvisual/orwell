defmodule Orwell.GitHub do
  alias Orwell.GitHub

  @spec commit(binary, binary) :: {atom, binary}
  def commit(filename, body) do
    create_branch(filename)

    path = filename |> GitHub.Blog.post_path
    body = %{
      message: commit_message(filename),
      content: body |> Base.encode64,
      branch: filename,
    }

    {status, response} = GitHub.Contents.create(path, body)
    case status do
      201 -> {:ok, response["commit"]["html_url"]}
      _ -> {:error, response["message"]}
    end
  end

  @spec pull_request(binary, binary) :: {atom, binary}
  def pull_request(title, branch) do
    body = %{
      title: title,
      head: branch,
      base: "master",
      maintainer_can_modify: true,
    }

    {status, response} = GitHub.Pulls.create(body)

    case status do
      201 -> {:ok, response["html_url"]}
      _ -> {:error, response["message"]}
    end
  end

  @spec create_branch(binary) :: Integer
  defp create_branch(name) do
    master = GitHub.References.find("heads/master")
    ref = "refs/heads/" <> name

    %{ref: ref, sha: master["object"]["sha"]}
    |> GitHub.References.create
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
