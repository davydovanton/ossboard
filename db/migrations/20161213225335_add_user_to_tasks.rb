Hanami::Model.migration do
  change do
    alter_table :tasks do
      add_foreign_key :user_id, :users, on_delete: :cascade
    end
  end
end
