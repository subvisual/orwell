defmodule Orwell.GitHubTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Orwell.GitHub

  test "commit" do
    use_cassette "github_create_file" do
      {status, _url} = Orwell.GitHub.commit("hello.txt", "world")

      assert status == :ok
    end
  end

  test "pull_request" do
    use_cassette "github_create_pr" do
      Orwell.GitHub.commit("hello.txt", "world")

      {status, _url} = Orwell.GitHub.pull_request("New post", "hello.txt")

      assert status == :ok
    end
  end
end
