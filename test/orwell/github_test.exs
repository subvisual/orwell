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

  test "pull_requests" do
    use_cassette "github_list_pull_requests" do
      config = Orwell.GitHub.Config.new("")
      Orwell.GitHub.commit("hello.txt", "world", config)
      Orwell.GitHub.pull_request("New post", "hello.txt", config)

      {status, pull_requests} = Orwell.GitHub.pull_requests(config)

      assert status == :ok
      assert length(pull_requests) == 1
    end
  end

  test "next_post_id" do
    use_cassette "github_next_post_id" do
      config = Orwell.GitHub.Config.new("")
      Orwell.GitHub.commit("hello.txt", "world", config)
      Orwell.GitHub.pull_request("New post", "hello.txt", config)

      next_id = Orwell.GitHub.next_post_id(config)

      assert next_id > 1
    end
  end
end
