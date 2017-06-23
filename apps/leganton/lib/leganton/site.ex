defmodule Leganton.Site do
  use Ecto.Schema
  import Ecto.Changeset
  alias Leganton.Site


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "sites" do
    field :description, :string
    field :feeds, {:array, :string}
    field :title, :string
    field :url, :string
    has_many :entries, Leganton.Entry

    timestamps()
  end

  @doc false
  def changeset(%Site{} = site, attrs) do
    site
    |> cast(attrs, [:title, :description, :url, :feeds])
    |> validate_required([:title, :url, :feeds])
  end
end
