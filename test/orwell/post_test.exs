defmodule Orwell.PostTest do
  use ExUnit.Case
  doctest Orwell.Post

  test "yaml_front_matter" do
    post = Orwell.Post.new("A title", "A body")

    yaml = Orwell.Post.yaml_front_matter(post)

    assert yaml == ~S"""
    ---
    title: "A title"
    ---
    """
  end

  test "full_file" do
    post = Orwell.Post.new("A title", "A body")

    yaml = Orwell.Post.full_file(post)

    assert yaml == ~S"""
    ---
    title: "A title"
    ---

    A body
    """
  end
end
