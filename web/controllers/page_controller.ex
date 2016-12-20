defmodule Etchsketch.PageController do
  use Etchsketch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
