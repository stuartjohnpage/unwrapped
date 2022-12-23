defmodule UnwrappedWeb.PageController do
  use UnwrappedWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
