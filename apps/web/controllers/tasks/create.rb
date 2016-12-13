module Web::Controllers::Tasks
  class Create
    include Web::Action

    expose :task

    params do
      required(:task).schema do
        required(:title).filled(:str?)
        required(:md_body).filled(:str?)
        required(:lang).filled(:str?)
        required(:user_id).filled
      end
    end

    def call(params)
      if params.valid? && authenticated?
        task_params = params[:task]
        task_params[:body] = Markdown.parse(task_params[:md_body])

        TaskRepository.new.create(task_params)
        redirect_to routes.tasks_path
      else
        @task = Task.new(params[:task])
        self.body = Web::Views::Tasks::New.render(format: format, task: @task, current_user: current_user, params: params)
      end
    end
  end
end
