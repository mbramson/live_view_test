defmodule LiveTest.ValidationTest do
  use LiveTest.DataCase

  alias LiveTest.Validation

  describe "things" do
    alias LiveTest.Validation.Thing

    @valid_attrs %{name: "some name", number: 42, other_name: "some other_name"}
    @update_attrs %{name: "some updated name", number: 43, other_name: "some updated other_name"}
    @invalid_attrs %{name: nil, number: nil, other_name: nil}

    def thing_fixture(attrs \\ %{}) do
      {:ok, thing} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Validation.create_thing()

      thing
    end

    test "list_things/0 returns all things" do
      thing = thing_fixture()
      assert Validation.list_things() == [thing]
    end

    test "get_thing!/1 returns the thing with given id" do
      thing = thing_fixture()
      assert Validation.get_thing!(thing.id) == thing
    end

    test "create_thing/1 with valid data creates a thing" do
      assert {:ok, %Thing{} = thing} = Validation.create_thing(@valid_attrs)
      assert thing.name == "some name"
      assert thing.number == 42
      assert thing.other_name == "some other_name"
    end

    test "create_thing/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Validation.create_thing(@invalid_attrs)
    end

    test "update_thing/2 with valid data updates the thing" do
      thing = thing_fixture()
      assert {:ok, %Thing{} = thing} = Validation.update_thing(thing, @update_attrs)
      assert thing.name == "some updated name"
      assert thing.number == 43
      assert thing.other_name == "some updated other_name"
    end

    test "update_thing/2 with invalid data returns error changeset" do
      thing = thing_fixture()
      assert {:error, %Ecto.Changeset{}} = Validation.update_thing(thing, @invalid_attrs)
      assert thing == Validation.get_thing!(thing.id)
    end

    test "delete_thing/1 deletes the thing" do
      thing = thing_fixture()
      assert {:ok, %Thing{}} = Validation.delete_thing(thing)
      assert_raise Ecto.NoResultsError, fn -> Validation.get_thing!(thing.id) end
    end

    test "change_thing/1 returns a thing changeset" do
      thing = thing_fixture()
      assert %Ecto.Changeset{} = Validation.change_thing(thing)
    end
  end
end
