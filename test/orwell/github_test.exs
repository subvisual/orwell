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
end
