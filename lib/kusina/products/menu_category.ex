defmodule Kusina.Products.MenuCategory do
  use Ecto.Schema

  import Ecto.Changeset

  schema "menu_categories" do
    field(:name, :string)
    field(:delete, :boolean, virtual: true)

    belongs_to(:menu, Kusina.Products.Menu)

    has_many(:items, Kusina.Products.MenuItem)
  end

  @required [:menu_id]
  @attrs @required

  def changeset(model_or_changeset, attrs \\ %{}) do
    model_or_changeset
    |> cast(attrs, @attrs)
    |> validate_required(@required)
    |> maybe_mark_for_deletion()
  end

  defp maybe_mark_for_deletion(%{data: %{id: nil}} = changeset), do: changeset

  defp maybe_mark_for_deletion(changeset) do
    if get_change(changeset, :delete) do
      %{changeset | action: :delete}
    else
      changeset
    end
  end
end
