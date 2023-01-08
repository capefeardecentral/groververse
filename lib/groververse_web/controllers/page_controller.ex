defmodule GroververseWeb.PageController do
  use GroververseWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
