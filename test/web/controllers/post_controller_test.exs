defmodule Orwell.Web.PostControllerTest do
  use Orwell.Web.ConnCase

  @valid_post_params [
    title: "A title",
    body: "A body",
    cover_url: "http://a-url.com/an-image.jpg",
    retina_cover_url: "http://an-image.jpg",
    tags: "a, b, c",
    intro: "An intro",
  ]

  @invalid_post_params Keyword.put(@valid_post_params, :title, nil)

  test "GET /posts", %{conn: conn} do
    conn = sign_in conn
    conn = get conn, post_path(conn, :index)

    assert html_response(conn, 200)
    assert conn.assigns[:posts]
  end

  test "POST /posts with valid post parameters", %{conn: conn} do
    conn = sign_in conn
    conn = post conn, post_path(conn, :create), [post: @valid_post_params]

    assert html_response(conn, 200) =~ "Post is valid"
  end

  test "POST /posts with invalid post parameters", %{conn: conn} do
    conn = sign_in conn
    conn = post conn, post_path(conn, :create), [post: @invalid_post_params]

    assert html_response(conn, 200) =~ "You messed something up"
  end
end
