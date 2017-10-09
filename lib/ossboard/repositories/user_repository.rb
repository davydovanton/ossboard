class UserRepository < Hanami::Repository
  associations do
    has_many :tasks
    has_many :accounts
    has_many :repos
  end

  def admins
    users.where(admin: true).map_to(User).to_a
  end

  def all_from_date(from)
    all_from_date_request(from).map_to(User).to_a
  end

  def count_all_from_date(from)
    result = all_from_date_request(from)
      .project { [int::count(:id), time::date_trunc('day', created_at).as(:created_at_day)] }
      .group   { date_trunc('day', :created_at) }
      .order(nil)

    result.to_a.each_with_object({}) {  |record, hsh| hsh[Date.parse(record.created_at_day.to_s)] = record.count }
  end

  def find_by_login(login)
    users.where(login: login).map_to(User).one
  end

  def find_by_login_with_tasks(login)
    aggregate(:tasks).where(login: login).map_to(User).one
  end

  def find_with_tasks(id)
    aggregate(:tasks).where(id: id).map_to(User).one
  end

  private

  def all_from_date_request(from)
    users.where { (created_at > from) & (created_at < Time.now) }
  end
end
