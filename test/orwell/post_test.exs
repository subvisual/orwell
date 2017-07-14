defmodule Orwell.PostTest do
  use ExUnit.Case
  doctest Orwell.Post

  @valid_post_params %{
    "id" => 1,
    "title" => "A title",
    "body" => "A body",
    "cover_url" => "a cover",
    "retina_cover_url" => "a cover",
    "tags" => "a,b,c",
    "intro" => "a cover",
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

  test "post is valid with correct params" do
    post = Orwell.Post.from_params(@valid_post_params)

    assert Vex.valid?(post)
  end

  test "id is required to be a number" do
    post = Orwell.Post.from_params(@valid_post_params)
           |> Map.put(:id, "this-is-not-a-number")

    assert not Vex.valid?(post)
    assert [{:error, :id, _, _}] = Vex.errors(post)
  end
end
