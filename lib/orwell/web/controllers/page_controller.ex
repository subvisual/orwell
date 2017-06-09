defmodule Orwell.Web.PageController do
  use Orwell.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
