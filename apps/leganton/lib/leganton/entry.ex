defmodule Leganton.Entry do
  use Ecto.Schema
  import Ecto.Changeset
  alias Leganton.Entry


  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "entries" do
    field :description, :string
    field :pubdate, :date
    field :title, :string
    field :url, :string
    field :read, :boolean, default: false
    belongs_to :site, Leganton.Site

    timestamps()
  end

  @doc false
  def changeset(%Entry{} = entry, attrs) do
    entry
    |> cast(attrs, [:title, :url, :description, :pubdate, :read])
    |> validate_required([:title, :url, :description, :pubdate])
  end
end
