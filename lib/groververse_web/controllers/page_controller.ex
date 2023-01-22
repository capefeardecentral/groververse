defmodule GroververseWeb.PageController do
  use GroververseWeb, :controller

  alias Groververse.Post
  alias Groververse.Repo

  def index(conn, _params) do
    posts = Post.get_all_posts()
    render(conn, "index.html", posts: posts)
  end

end
