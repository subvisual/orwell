defmodule Orwell.PostTest do
  use ExUnit.Case
  doctest Orwell.Post

  @valid_post_params %{
    "id" => 1,
    "path" => "path/to/file",
    "title" => "A title",
    "body" => "A body",
    "author" => "hemingway",
    "date" => "01/01/1970",
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
    id: 1
    path: path/to/file
    title: "A title"
    author: hemingway
    date: 01/01/1970
    cover: a cover
    retina_cover: a cover
    tags:
      - a
      - b
      - c
    intro: "a cover"
    ---
    """
  end

  test "full_file" do
    post = Orwell.Post.from_params(@valid_post_params)

    yaml = Orwell.Post.full_file(post)

    assert yaml == ~S"""
    ---
    id: 1
    path: path/to/file
    title: "A title"
    author: hemingway
    date: 01/01/1970
    cover: a cover
    retina_cover: a cover
    tags:
      - a
      - b
      - c
    intro: "a cover"
    ---

    A body
    """
  end

  test "formatted_utc_today" do
    date = Orwell.Post.formatted_utc_today()

    assert Regex.match?(~r|\d{2}/\d{2}/\d{4}|, date)
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
