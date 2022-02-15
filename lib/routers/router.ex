defmodule Friends.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Rest API by Joeri\n")
  end

  forward "/records", to: Friends.Router.RecordRouter

  match _ do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Oops! Page not found\n")
  end

  def send_json(conn, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, Jason.encode!(body))
  end
end
