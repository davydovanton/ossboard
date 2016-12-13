class UserRepository < Hanami::Repository
  associations do
    has_many :tasks
  end

  def find_by_uuid(uuid)
    users.where(uuid: uuid).as(User).first
  end

  def find_with_tasks(id)
    aggregate(:tasks).where(id: id).as(User).one
  end
end
