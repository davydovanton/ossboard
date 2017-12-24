Hanami::Model.migration do
  change do
    add_column :tasks, :first_pr, TrueClass, default: false
  end
end
