module Web::Controllers::Tasks
  class Create
    include Web::Action

    expose :task

    params do
      required(:task).schema do
        required(:title).filled(:str?)
        required(:md_body).filled(:str?)
        required(:lang).filled(:str?)
        required(:complexity).filled(:str?)
        required(:time_estimate).filled(:str?)
        required(:user_id).filled
        optional(:issue_url).maybe(:str?)
        optional(:repository_name).maybe(:str?)
      end
    end

    def call(params)
      if params.valid? && authenticated?
        task = TaskRepository.new.create(task_params)

        NewTaskNotificationWorker.perform_async(task.id)
        flash[:info] = INFO_MESSAGE

        redirect_to routes.tasks_path
      else
        @task = Task.new(params[:task])
        self.body = Web::Views::Tasks::New.render(format: format, task: @task,
          current_user: current_user, params: params, updated_csrf_token: set_csrf_token)
      end
    end

    private

    INFO_MESSAGE = 'Task had been added to moderation. You can check your task status on profile page'.freeze

    def task_params
      hash = params[:task]
      hash[:body] = Container[:markdown].call(hash[:md_body])
      hash[:status] = Task::VALID_STATUSES[:in_progress]
      hash[:approved] = nil
      hash
    end
  end
end
