class ApproveTaskWorker
  include Sidekiq::Worker

  def perform(task_id)
    task = TaskRepository.new.find(task_id)
    user = UserRepository.new.find(task.user_id)

    return unless task

    Mailers::TaskApproved.deliver(user: user, task: task, format: :html)
    TaskTwitter.call(task)
  end
end
