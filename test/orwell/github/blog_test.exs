defmodule Orwell.GitHub.BlogTest do
  use ExUnit.Case
  alias Orwell.GitHub
  doctest Orwell.GitHub.Blog

  test "post_path/0" do
    base_path = Application.get_env(:orwell, :github_posts_dir)
    regex = ~r/#{base_path}\/\d{4}\/\d{2}-\w+/

    assert Regex.match?(regex, GitHub.Blog.post_path())
  end

  test "post_path/1" do
    base_path = Application.get_env(:orwell, :github_posts_dir)
    file = "hello.txt"
    regex = ~r/#{base_path}\/\d{4}\/\d{2}-\w+\/#{file}/

    assert Regex.match?(regex, GitHub.Blog.post_path(file))
  end

  test "post_id/1" do
    post_path = "pages/posts/2017/06-june/062-the-brown-fox-jumps-over-the-lazy-dog.md"

    assert GitHub.Blog.post_id(post_path) == 62
  end
end
