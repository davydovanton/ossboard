Hanami::Model.migration do
  change do
    rename_column :tasks, :md_body, :description
  end
end
