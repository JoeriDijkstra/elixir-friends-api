defmodule Friends.Person do
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:id, :first_name, :last_name, :age]}
  schema "people" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
  end

  def insert(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:first_name, :last_name, :age])
    |> Ecto.Changeset.validate_required([:first_name, :last_name])
    |> Friends.Repo.insert
  end
end
