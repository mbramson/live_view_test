defmodule LiveTest.Repo.Migrations.CreateThings do
  use Ecto.Migration

  def change do
    create table(:things) do
      add :name, :string
      add :number, :integer
      add :other_name, :string

      timestamps()
    end

  end
end
