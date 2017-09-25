class User < Hanami::Entity
  attributes do
    attribute :id,             Types::Int
    attribute :count,          Types::Int
    attribute :name,           Types::String
    attribute :login,          Types::String
    attribute :email,          Types::String
    attribute :avatar_url,     Types::String
    attribute :bio,            Types::String
    attribute :admin,          Types::Bool
    attribute :created_at,     Types::Time
    attribute :updated_at,     Types::Time
    attribute :created_at_day, Types::Date

    attribute :tasks,    Types::Collection(Task)
    attribute :repos,    Types::Collection(Repo)
    attribute :accounts, Types::Collection(Account)
  end

  def registred?
    !!id
  end

  def author?(task)
    id == task.user_id
  end

  def can_edit_task?(task)
    registred? && author?(task) && !task.approved
  end
end
