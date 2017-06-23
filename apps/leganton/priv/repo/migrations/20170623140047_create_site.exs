defmodule Leganton.Repo.Migrations.CreateLeganton.Site do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :description, :text
      add :url, :string
      add :feeds, {:array, :string}

      timestamps()
    end

  end
end
