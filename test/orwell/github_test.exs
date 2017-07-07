defmodule Orwell.GitHubTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Orwell.GitHub

  test "posts" do
    use_cassette "github_list_posts" do
      config = Orwell.GitHub.Config.new("")
      {status, posts} = Orwell.GitHub.posts(config)

      assert status == :ok
      refute Enum.empty?(posts)
    end
  end

  # TODO: Enable the test after post creation is allowed
  # test "post" do
  #   use_cassette "github_show_post" do
  #     config = Orwell.GitHub.Config.new("")

  #     {status, post} = Orwell.GitHub.post()
  #   end
  # end

  test "commit" do
    use_cassette "github_create_file" do
      config = Orwell.GitHub.Config.new("")
      {status, _url} = Orwell.GitHub.commit("hello.txt", "world", config)

      assert status == :ok
    end
  end

  test "pull_request" do
    use_cassette "github_create_pr" do
      config = Orwell.GitHub.Config.new("")
      Orwell.GitHub.commit("hello.txt", "world", config)

      {status, _url} = Orwell.GitHub.pull_request("New post", "hello.txt", config)

      assert status == :ok
    end
  end
end
