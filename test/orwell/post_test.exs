defmodule Orwell.PostTest do
  use ExUnit.Case
  doctest Orwell.Post

  @valid_post_params %{
    "title" => "A title",
    "body" => "A body"
  }

  test "yaml_front_matter" do
    post = Orwell.Post.from_params(@valid_post_params)

    yaml = Orwell.Post.yaml_front_matter(post)

    assert yaml == ~S"""
    ---
    title: "A title"
    ---
    """
  end

  test "full_file" do
    post = Orwell.Post.from_params(@valid_post_params)

    yaml = Orwell.Post.full_file(post)

    assert yaml == ~S"""
    ---
    title: "A title"
    ---

    A body
    """
  end
end
