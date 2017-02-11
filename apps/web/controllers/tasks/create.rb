require_relative './create_params'

module Web::Controllers::Tasks
  class Create
    include Web::Action

    expose :task
    params CreateParams

    def call(params)
      if params.valid? && authenticated?
        task_params = params[:task]
        task_params[:body] = Markdown.parse(task_params[:description])
        task_params[:status] = Task::VALID_STATUSES[:in_progress]
        task_params[:approved] = nil

        task = TaskRepository.new.create(task_params)

        NewTaskNotificationWorker.perform_async(task.id)
        flash[:info] = 'Task had been added to moderation. You can check your task status on profile page'

        redirect_to routes.tasks_path
      else
        @task = Task.new(params[:task])
        self.body = Web::Views::Tasks::New.render(format: format, task: @task,
          current_user: current_user, params: params, updated_csrf_token: set_csrf_token)
      end
    end
  end
end
