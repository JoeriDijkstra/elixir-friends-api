defmodule Friends.Router.RecordRouter do
  require Ecto.Query
  use Plug.Router

  plug :match

  plug Plug.Parsers,
  parsers: [:json],
  pass:  ["application/json"],
  json_decoder: Jason

  plug :dispatch

  post "/create" do
    params = conn.body_params

    # Build person
    person = %Friends.Person{
      first_name: params["fname"],
      last_name: params["lname"],
      age: params["age"]
    }

    # Insert and send response
    {:ok, inserted_person} = Friends.Person.insert(person)
    send_resp(conn, 200, "OK, ID: #{inserted_person.id}")
  end

  get "/" do
    person = Friends.Person
    |> Friends.Repo.all

    Friends.Router.send_json(conn, person)
  end

  get "/first" do
    person = Friends.Person
    |> Ecto.Query.first
    |> Friends.Repo.one

    Friends.Router.send_json(conn, person)
  end

  get "/last" do
    person = Friends.Person
    |> Ecto.Query.last
    |> Friends.Repo.one

    Friends.Router.send_json(conn, person)
  end

  get "/id/:input" do
    person = Friends.Person
    |> Ecto.Query.where(id: ^input)
    |> Friends.Repo.one

    Friends.Router.send_json(conn, person)
  end

  delete "/id/:input" do
    person = Friends.Person
    |> Ecto.Query.where(id: ^input)
    |> Friends.Repo.one

    cond do
      person != nil ->
        Friends.Repo.delete(person)
        send_resp(conn, 200, "Removed succesfully")
      person == nil ->
        send_resp(conn, 200, "User not found")
    end
  end

  get "/first_name/:input" do
    person = Friends.Person
    |> Ecto.Query.where(first_name: ^input)
    |> Friends.Repo.all

    Friends.Router.send_json(conn, person)
  end

  get "/last_name/:input" do
    person = Friends.Person
    |> Ecto.Query.where(last_name: ^input)
    |> Friends.Repo.all

    Friends.Router.send_json(conn, person)
  end

  match _ do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(404, "Oops! Not a valid get request\n")
  end
end
