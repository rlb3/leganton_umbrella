defmodule Leganton.Repo.Migrations.CreateLeganton.Entry do
  use Ecto.Migration

  def change do
    create table(:entries, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :url, :string
      add :description, :text
      add :pubdate, :date
      add :read, :boolean
      add :site_id, references(:sites, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:entries, [:site_id])
  end
end
