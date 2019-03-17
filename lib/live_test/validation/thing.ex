defmodule LiveTest.Validation.Thing do
  use Ecto.Schema
  import Ecto.Changeset

  schema "things" do
    field :name, :string
    field :number, :integer
    field :other_name, :string

    timestamps()
  end

  @doc false
  def changeset(thing, attrs) do
    thing
    |> cast(attrs, [:name, :number, :other_name])
  end
end
