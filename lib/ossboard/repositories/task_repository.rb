class TaskRepository < Hanami::Repository
  def only_approved
    tasks.where(approved: true).order { id.desc }.map_to(Task).to_a
  end

  def not_approved
    tasks.where(approved: false).map_to(Task).to_a
  end

  def new_tasks
    tasks.where(approved: nil).map_to(Task).to_a
  end

  def all_from_date(from, status = nil)
    all_from_date_request(from, status).map_to(Task).to_a
  end

  def all_from_date_counted_by_status_and_day(from)
    result = all_from_date_request(from)
      .project { [int::count(:id), status, time::date_trunc('day', created_at).as(:created_at_day)] }
      .group   { [:status, :created_at_day] }
      .order(nil).to_a
      .group_by(&:status)

    result.each do |status, records_by_status|
      result[status] = {}
      records_by_status.each { |record| result[status][Date.parse(record.created_at_day.to_s)] = record.count }
    end
  end

  def find_by(params = {})
    tasks.where(params).order { id.desc }.map_to(Task).to_a
  end

  def assigned_tasks_for_user(user)
    tasks.where(assignee_username: user.login).order { id.desc }.map_to(Task).to_a
  end

  def for_first_pr
    tasks.where(first_pr: true).order { id.desc }.map_to(Task).to_a
  end

  private

  def all_from_date_request(from, status = nil)
    request = tasks.where { (created_at > from) & (created_at < Time.now) }
    request = request.where(status: status) if status
    request
  end
end
