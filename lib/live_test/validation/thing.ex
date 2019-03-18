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
    |> validate_inclusion(:number, -1000..1000, message: "That number is too intense!")
    |> validate_format(:name, ~r/^[A-Za-z\s]*$/, message: "No numbers!")
    |> validate_length(:name, min: 5)
  end
end
