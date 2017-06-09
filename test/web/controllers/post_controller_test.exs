defmodule Orwell.Web.PostControllerTest do
  use Orwell.Web.ConnCase

  test "POST /posts", %{conn: conn} do
    conn = post conn, post_path(conn, :create), [post: [title: "Baderous", body: "Baderous"]]

    assert html_response(conn, 200)
    assert conn.assigns[:markdown]
  end
end
