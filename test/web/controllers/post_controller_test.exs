defmodule Orwell.Web.PostControllerTest do
  use Orwell.Web.ConnCase

  test "GET /posts", %{conn: conn} do
    conn = sign_in conn
    conn = get conn, post_path(conn, :index)

    assert html_response(conn, 200)
    assert conn.assigns[:posts]
  end

  test "POST /posts", %{conn: conn} do
    conn = sign_in conn
    conn = post conn, post_path(conn, :create), [post: [title: "Baderous", body: "Baderous"]]

    assert html_response(conn, 200)
    assert conn.assigns[:markdown]
  end
end
